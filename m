Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76AA26C98A
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 21:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgIPRkj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 13:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgIPRi5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:38:57 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7DA320672;
        Wed, 16 Sep 2020 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600277937;
        bh=bfX+0DQuubQXMd5NiC/8C3Cu/YAMMBG+w6qlM9Bar6I=;
        h=From:To:Cc:Subject:Date:From;
        b=gAgB1IwPs8+D8uJQp31WjVEaSoA3mwT+mBpWZ6Dj2Svyl2EASkuEx3ngat1DkrIfH
         1375bcVQMWGloDsdbdGIowZPXYbCo/4JGZRtBjh6ptduQCNUTUEMP4HE7/S2R9VLS3
         ub/fyxIWnzQ2UaNtpkEQhA4BqLZa/VLFs0ZJL4wg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com
Subject: [PATCH 0/5] ceph: addr.c cleanups
Date:   Wed, 16 Sep 2020 13:38:49 -0400
Message-Id: <20200916173854.330265-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This set cleans up and reorganizes the readpage, writepage and
write_begin code in ceph, with the resulting code (hopefully) being a
bit more clear. There should be no behavioral changes here.

This should also help prepare ceph for some coming changes to the fscache
infrastructure and fscrypt I/O path integration.

There's also a modest reduction in LoC.

Jeff Layton (5):
  ceph: break out writeback of incompatible snap context to separate
    function
  ceph: don't call ceph_update_writeable_page from page_mkwrite
  ceph: fold ceph_sync_readpages into ceph_readpage
  ceph: fold ceph_sync_writepages into writepage_nounlock
  ceph: fold ceph_update_writeable_page into ceph_write_begin

 fs/ceph/addr.c | 369 ++++++++++++++++++++++---------------------------
 1 file changed, 169 insertions(+), 200 deletions(-)

-- 
2.26.2

