Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339384B71CD
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 17:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiBOOwN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 09:52:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239247AbiBOOvw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 09:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F110528C
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:50:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2868561469
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 14:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DACC340EB;
        Tue, 15 Feb 2022 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936643;
        bh=I6ClGvqxWfxS6t+qnVXIoYNdlY8VGu/51fbaFHyJfnY=;
        h=From:To:Cc:Subject:Date:From;
        b=VPrTerbgycsm1M3lqTtM1uWx+NsceXfVwlAh6PKoO+ut3sZTwBHE6dsadFc63fz9m
         6zsJbOfjiGyzHRblYb5Wq+j/X5m9ATDT5x9wBOE9UKN73Bz5y8rOj7okItA7/nXPnB
         kD/nzxo0B0A0ygtX1lb0uV0gjmmgO88jmNWv/8z+qcZEGKvTUBLyEqwnjMqhAsNWEG
         P2BZ4QKBKM0PNIIGWXy9kG5iWWR0NL9Oscw/3Ka5B1XuYFF5cOXsK6XnGIY/bkDuWV
         ey5qhkq/GPMQUVB8Xx1x15CdThAlGd0ekcL7kK2ZPeEQnnDmCoRmqhSJRW8RH9mYyN
         A4WewRlnxZ0JQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [RFC PATCH 0/5] libceph: add support for sparse reads to msgr2/crc
Date:   Tue, 15 Feb 2022 09:50:36 -0500
Message-Id: <20220215145041.26065-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a first stab at a patchset to add support for sparse reads to
libceph. This is a prerequisite for fscrypt support, since we need to be
able to know whether a region is sparse in order to know whether we need
to decrypt it.

The patches basically work at this point, but it's still a RFC
for a few reasons:

1) the ms_mode=secure and ms_mode=legacy codepaths are not yet
supported. "legacy" doesn't look too bad, but "secure" is a bit
tougher, as I'd like to avoid extra buffering.

2) the OSD currently throws back -EINVAL on a sparse read if an extent
has a non-zero truncate_seq. I've opened this bug to request that this
be remedied: https://tracker.ceph.com/issues/54280

3) I'm not sure I got the revoke_at_* patch correct. I added a new field
to the v2_info structure. Maybe there is some better way to handle that?
What's the best way to test the revocation codepaths?

I ran this through xfstests yesterday, and several of them failed
because of #2 above, but it didn't oops!

Jeff Layton (5):
  libceph: allow ceph_msg_data_advance to advance more than a page
  libceph: add sparse read support to msgr2 crc state machine
  libceph: add sparse read support to OSD client
  libceph: add revoke support for sparse data
  ceph: switch to sparse reads

 fs/ceph/addr.c                  |   2 +-
 fs/ceph/file.c                  |   4 +-
 include/linux/ceph/messenger.h  |  20 ++++
 include/linux/ceph/osd_client.h |  37 ++++++
 net/ceph/messenger.c            |  12 +-
 net/ceph/messenger_v2.c         | 195 +++++++++++++++++++++++++++++---
 net/ceph/osd_client.c           | 161 +++++++++++++++++++++++++-
 7 files changed, 408 insertions(+), 23 deletions(-)

-- 
2.34.1

