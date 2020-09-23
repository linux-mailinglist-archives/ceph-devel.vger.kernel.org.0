Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1143C275776
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Sep 2020 13:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgIWLwE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Sep 2020 07:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgIWLwE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 07:52:04 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51E72193E
        for <ceph-devel@vger.kernel.org>; Wed, 23 Sep 2020 11:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600861924;
        bh=E2c6JAZSru7S3wPFsTWjmclP6a8Wd/2BesxKOHiiMd4=;
        h=From:To:Subject:Date:From;
        b=F2ym9lg/5FrTh7XBRJMWZmDKYOs/AWnphZu4MLIlyZ2t3FVINVeLAm8KemVdIxIXT
         aW2yF2zb7891j1hvC+ZKD0RThFtt/sG8XRnaOCle21Z7i2oj7QyQJDR/WAdTHQtyiA
         mVTlJLuzBUtb+O0nw0msCAyQu4kOzxI40iW0xSgE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 0/5] ceph: addr.c cleanups
Date:   Wed, 23 Sep 2020 07:51:56 -0400
Message-Id: <20200923115201.15664-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a minor revision to the set that I sent last week to clean up
some of the addr.c code. The main changes are to comments and
whitespace, but I also eliminated the unneeded inode argument to
ceph_find_incompatible.

Jeff Layton (5):
  ceph: break out writeback of incompatible snap context to separate
    function
  ceph: don't call ceph_update_writeable_page from page_mkwrite
  ceph: fold ceph_sync_readpages into ceph_readpage
  ceph: fold ceph_sync_writepages into writepage_nounlock
  ceph: fold ceph_update_writeable_page into ceph_write_begin

 fs/ceph/addr.c | 384 ++++++++++++++++++++++---------------------------
 1 file changed, 175 insertions(+), 209 deletions(-)

-- 
2.26.2

