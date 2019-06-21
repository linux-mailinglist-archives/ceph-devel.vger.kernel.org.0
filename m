Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F8E4EA70
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Jun 2019 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFUOSg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jun 2019 10:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfFUOSg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 10:18:36 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0EBB20679;
        Fri, 21 Jun 2019 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561126715;
        bh=utpNSfhfqDUGvBr9WSoyJ8v2U6SsAumLTAISUYtlQTY=;
        h=From:To:Cc:Subject:Date:From;
        b=eRaYWm9YQG+vjmKWshHLBOcgeJpq63PTM/hsvBnkJzVYfsqhUV51SAFEgR+v+xBPj
         IiM5mHFJnjB/ZeuUpREW6v6K9uiwDFWK3VR2+E661IoaaJmZQK8rpYIJbEBXKmIdG7
         Bdz7S1xcCTEaaks8+NMyEWVgZ9aaeuLNZh1rA1OY=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, geert+renesas@glider.be,
        andriy.shevchenko@linux.intel.com
Subject: [PATCH v3 0/2] ceph: don't NULL terminate virtual xattr values
Date:   Fri, 21 Jun 2019 10:18:31 -0400
Message-Id: <20190621141833.17551-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v3: switch to using an intermediate buffer for snprintf destination
    add patch to fix ceph_vxattrcb_layout return value
v2: drop bogus EXPORT_SYMBOL of static function

This is the 3rd posting of this patchset. Instead of adding a new
snprintf variant that doesn't NULL terminate, this set instead has
the vxattr handlers use an intermediate buffer as the snprintf
destination and then memcpy's the result into the destination buffer.

Also, I added a patch to fix up the return of ceph_vxattrcb_layout. The
existing code actually worked, but relied on casting a signed negative
value to unsigned and back, which seemed a little sketchy.

Most of the rationale for this set is in the description of the first
patch of the series.

Jeff Layton (2):
  ceph: fix buffer length handling in virtual xattrs
  ceph: fix return of ceph_vxattrcb_layout

 fs/ceph/xattr.c | 113 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 81 insertions(+), 32 deletions(-)

-- 
2.21.0

