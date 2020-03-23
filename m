Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76D218F94B
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCWQHL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgCWQHL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:11 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5211720637;
        Mon, 23 Mar 2020 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979630;
        bh=o95RzpTAiQw/tYrbSicrUDg7YuHGkbOceJZ3hi5JCA4=;
        h=From:To:Cc:Subject:Date:From;
        b=VvYh1Tl6ZxadSYy1zWQ0+sOVSS8/AAOefsXtfrjptpEo7J2IOPO2pZ0mZs7tuG0mN
         WHBQWuj8ykbRK5qH9TLCmyhl6NLYgEqLZTCS5YAbeFfW74Pe9GWZbid+CKc+slO/H6
         BqMtYpZvXgWcavpIZjBstgPIE9L8iTR3/BzHswks=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 0/8] ceph: cap handling code fixes, cleanups and comments
Date:   Mon, 23 Mar 2020 12:07:00 -0400
Message-Id: <20200323160708.104152-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been going over the cap handling code with an aim toward
simplifying the locking. There's one fix for a potential use-after-free
race in here. This also eliminates a number of __acquires and __releases
annotations by reorganizing the code, and adds some (hopefully helpful)
comments.

There should be no behavioral changes with this set.

Jeff Layton (8):
  ceph: reorganize __send_cap for less spinlock abuse
  ceph: split up __finish_cap_flush
  ceph: add comments for handle_cap_flush_ack logic
  ceph: don't release i_ceph_lock in handle_cap_trunc
  ceph: don't take i_ceph_lock in handle_cap_import
  ceph: document what protects i_dirty_item and i_flushing_item
  ceph: fix potential race in ceph_check_caps
  ceph: throw a warning if we destroy session with mutex still locked

 fs/ceph/caps.c       | 292 ++++++++++++++++++++++++-------------------
 fs/ceph/mds_client.c |   1 +
 fs/ceph/super.h      |   4 +-
 3 files changed, 170 insertions(+), 127 deletions(-)

-- 
2.25.1

