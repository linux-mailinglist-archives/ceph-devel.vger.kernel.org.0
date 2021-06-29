Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0D53B7046
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 11:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhF2JuS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 05:50:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56200 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhF2JuS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 05:50:18 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B007203C3;
        Tue, 29 Jun 2021 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/BBoHi0z9IUfnsUqjW/5oi4vDZO4ru/QfDZ4Un4aQIs=;
        b=Ot/8kwhZmcs7g5i0orH7hLbhg7Pz663Z9oSTc7T9laeG/AaTRzBnKsODuF+nVZgAYoH0E7
        XRIvr8FufYi+Kom1EVXHnaUSsg3PmbJR5Az/mZZAl1cOooImII3ySjl/lyKDdVWs4B+REe
        fv9RjxjquVx3EOzt7g9XhaOJMNWE8hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960070;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/BBoHi0z9IUfnsUqjW/5oi4vDZO4ru/QfDZ4Un4aQIs=;
        b=2O5TJA6db4B3rNG8CH05CDhnE3e3xUx2XFwrZVXduaPxI9sIcgJ070IDCup98Y27q/Wb6T
        7918zHLmGrdpc4BA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 121CF11906;
        Tue, 29 Jun 2021 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/BBoHi0z9IUfnsUqjW/5oi4vDZO4ru/QfDZ4Un4aQIs=;
        b=Ot/8kwhZmcs7g5i0orH7hLbhg7Pz663Z9oSTc7T9laeG/AaTRzBnKsODuF+nVZgAYoH0E7
        XRIvr8FufYi+Kom1EVXHnaUSsg3PmbJR5Az/mZZAl1cOooImII3ySjl/lyKDdVWs4B+REe
        fv9RjxjquVx3EOzt7g9XhaOJMNWE8hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960070;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/BBoHi0z9IUfnsUqjW/5oi4vDZO4ru/QfDZ4Un4aQIs=;
        b=2O5TJA6db4B3rNG8CH05CDhnE3e3xUx2XFwrZVXduaPxI9sIcgJ070IDCup98Y27q/Wb6T
        7918zHLmGrdpc4BA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id xfvGAEbs2mBqawAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 09:47:49 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id de86c188;
        Tue, 29 Jun 2021 09:47:49 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [RFC PATCH v2 0/2] ceph_check_delayed_caps() softlockup
Date:   Tue, 29 Jun 2021 10:47:47 +0100
Message-Id: <20210629094749.25253-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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
 fs/ceph/mds_client.c | 24 +++++++++++++++---------
 fs/ceph/super.h      |  2 +-
 3 files changed, 32 insertions(+), 11 deletions(-)

