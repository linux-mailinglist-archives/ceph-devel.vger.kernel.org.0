Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154DB444083
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 12:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhKCL0p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 07:26:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45870 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhKCL0p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 07:26:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BDF682191C;
        Wed,  3 Nov 2021 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635938647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BHM6beP+ci2YS6uIcC6WhOsbWfLFD9wsRR53HzpdgUM=;
        b=aUXZoGnM43lnNBeiJVmiPpqCxkdSEe11FHG6BQqndjcWaC+DFMn6JT07p6FfmuDDROIA4t
        QgZltGjwHW351qyJWjrFKZanEhsIu96S6qcj2HivC4NJNzON/Ka9/KGA8S+na5Jjv6ZM2k
        whTztbH0LNe04g497Nujuv1FJmD+tfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635938647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BHM6beP+ci2YS6uIcC6WhOsbWfLFD9wsRR53HzpdgUM=;
        b=zEcEpjgnjJLuKhNGrsECZwh2sqM8Ck2xXQOSUQAgiJCUFzLtscvfx1xGbmyMrNUoiiCbhs
        x7YhJ7jgMDNvgSCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5094E13DC1;
        Wed,  3 Nov 2021 11:24:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vpj5EFdxgmHyMQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 03 Nov 2021 11:24:07 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 6c93fdf8;
        Wed, 3 Nov 2021 11:24:06 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 0/2] ceph: metrics for remote object copies
Date:   Wed,  3 Nov 2021 11:24:03 +0000
Message-Id: <20211103112405.8733-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Following this email, I'm sending two patches that add support for a an
extra metric in the cephfs metrics infrastructure.

The 1st patch modifies libceph so that ceph_osdc_copy_from() returns an
OSD request and makes it responsibility of the caller to do the wait (and
release the request).  This is required so that the callers (currently
only the copy_file_range() syscall code) can access the request latency
timestamps.

The 2nd patch effectively adds support for the 'copyfrom' metrics.

Luís Henriques (2):
  libceph: have ceph_osdc_copy_from() return the osd request
  ceph: add a new metric to keep track of remote object copies

 fs/ceph/debugfs.c               |  3 ++-
 fs/ceph/file.c                  | 13 ++++++++++++-
 fs/ceph/metric.h                |  8 ++++++++
 include/linux/ceph/osd_client.h | 21 +++++++++++----------
 net/ceph/osd_client.c           | 27 ++++++++++++++-------------
 5 files changed, 47 insertions(+), 25 deletions(-)

