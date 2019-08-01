Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E690A7E409
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfHAU0I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfHAU0I (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:26:08 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 097852080C;
        Thu,  1 Aug 2019 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564691167;
        bh=jLU3KTSBpsrPujoOPCcAqEuPFYAsg1mmJubqFAMMP7Y=;
        h=From:To:Cc:Subject:Date:From;
        b=S1JdCGpuwmHdbZ9X2DP181mWVXCN8NCoB3+KEAukGK+RhTaOEjmtzYDFRwHoxOEWq
         TC572xol6U70twRX2DwuL2+vHULtrT78u/mFyNGPOSy0tZpreEsJUjVIuRuQOUOgUo
         e0rtcCtmSixhNKuzBGBRQmlI3kgz6IELyHtO/K30=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 0/9] ceph: add asynchronous unlink support
Date:   Thu,  1 Aug 2019 16:25:56 -0400
Message-Id: <20190801202605.18172-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I sent a preliminary patchset for this back in April, which relied
on a totally hacked-up MDS patchset. Since then, Zheng has modified
the approach somewhat to make the MDS grant the client explicit
capabilities for asynchronous directory operations.

This patchset is an updated version of the earlier set. With this,
and the companion MDS set in play, removing a directory with a large
number of files in it is roughly twice as fast as doing it
synchronously.

In addition this set includes some new tracepoints that allow the
admin to better view what's happening with caps. They're mostly
limited to unlink and cap handling here, but I expect we'll add
more of those as time goes on.

I don't think we'll want to merge this just yet, until the MDS
support is merged. Once that goes in, and assuming we don't have
any changes to the client/MDS interface, we should clear to do
so.

Jeff Layton (7):
  ceph: make several helper accessors take const pointers
  ceph: hold extra reference to r_parent over life of request
  ceph: register MDS request with dir inode from the get-go
  ceph: add refcounting for Fx caps
  ceph: wait for async dir ops to complete before doing synchronous dir
    ops
  ceph: new tracepoints when adding and removing caps
  ceph: add tracepoints for async and sync unlink

Yan, Zheng (2):
  ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
  ceph: perform asynchronous unlink if we have sufficient caps

 fs/ceph/Makefile                |   3 +-
 fs/ceph/caps.c                  |  88 +++++++++++++++++------
 fs/ceph/dir.c                   | 121 ++++++++++++++++++++++++++++++--
 fs/ceph/file.c                  |   4 ++
 fs/ceph/inode.c                 |   9 ++-
 fs/ceph/mds_client.c            |  27 +++----
 fs/ceph/super.h                 |  28 ++++----
 fs/ceph/trace.c                 |  76 ++++++++++++++++++++
 fs/ceph/trace.h                 |  86 +++++++++++++++++++++++
 include/linux/ceph/ceph_debug.h |   1 +
 include/linux/ceph/ceph_fs.h    |   9 +++
 11 files changed, 393 insertions(+), 59 deletions(-)
 create mode 100644 fs/ceph/trace.c
 create mode 100644 fs/ceph/trace.h

-- 
2.21.0

