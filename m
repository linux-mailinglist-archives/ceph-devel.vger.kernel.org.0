Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B203BD9DE
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGFPRb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 11:17:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33802 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhGFPR3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 11:17:29 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E269F1FF77;
        Tue,  6 Jul 2021 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625579563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cYuycIVYFqYGVzwo4RAZKWUEItNnBZQJ9IdSrK0ChLQ=;
        b=dr7bpW8S/qggHPipymiGhlkxMJxr6zmTUUbjcR4BeydH6XRuOQloHaw+MMvxMv7UaMW1rU
        ThJih7nK0sgpu1/tIP8uDFYW4cxVs3fpcu7NOSkKDIql2zz7m8DYK3BC6Z7PYOgvHGvXoc
        /Fnk1US2Tautf73WsfateZyyx86/NDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625579563;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cYuycIVYFqYGVzwo4RAZKWUEItNnBZQJ9IdSrK0ChLQ=;
        b=DfrcY1WXr8zkHR6AD1g3FDm4eTZBfkNbdoblYxQtC3Yj1aCX1TSwS/ictOo6VevgLCgRKa
        cBTEIWplvkEfDeAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 786D1133D0;
        Tue,  6 Jul 2021 13:52:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id UFlvGStg5GCPKAAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Tue, 06 Jul 2021 13:52:43 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 2e94826e;
        Tue, 6 Jul 2021 13:52:42 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH v3 0/2] ceph_check_delayed_caps() softlockup
Date:   Tue,  6 Jul 2021 14:52:40 +0100
Message-Id: <20210706135242.9978-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

* changes since v3:
  - always round the delay with round_jiffies_relative() in function
    schedule_delayed() (patch 0001)

This is an attempt to fix the softlock on the delayed_work workqueue.  As
stated in 0002 patch:

  Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
  workqueue and it can be kept looping for quite some time if caps keep being
  added back to the mdsc->cap_delay_list.  This may result in the watchdog
  tainting the kernel with the softlockup flag.

v2 of this fix modifies the approach by time-bounding the loop in this
function, so that any caps added to the list *after* the loop starts will
be postponed to the next wq run.

An extra change in 0001 (suggested by Jeff) allows scheduling runs for
periods smaller than the default (5 secs) period.  This way,
delayed_work() can have the next run scheduled for the next list element
ci->i_hold_caps_max instead of 5 secs.

This patchset should fix the issue reported here [1], although a quick
search for "ceph_check_delayed_caps" in the tracker returns a few more
bugs, possibly duplicates.

[1] https://tracker.ceph.com/issues/46284

Luis Henriques (2):
  ceph: allow schedule_delayed() callers to set delay for workqueue
  ceph: reduce contention in ceph_check_delayed_caps()

 fs/ceph/caps.c       | 17 ++++++++++++++++-
 fs/ceph/mds_client.c | 25 ++++++++++++++++---------
 fs/ceph/super.h      |  2 +-
 3 files changed, 33 insertions(+), 11 deletions(-)

