Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2602BAEF4
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Nov 2020 16:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKTPaI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Nov 2020 10:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKTPaI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 10:30:08 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE0622252;
        Fri, 20 Nov 2020 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605886208;
        bh=ExnUoPBgg+1rtoIgFak1kgenHKpFRt5KpO66wTiotZc=;
        h=From:To:Cc:Subject:Date:From;
        b=eEz3wNv9fhbWbTt2/RyRR2JxfjsRwSKqRaEa/412yk4+wRrIkA6rFq9ZoOsSp3zWi
         Ya/Uze5BGlBttuAWNVftcejxIzSh7MakPzMlCFCL6SsAXd1+8lQTFELiv4b8C+n3jp
         MuNoLosepN+KcEUTGhEQOqx+8MC/83hh+IOV2/to=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@redhat.com, dhowells@redhat.com
Subject: [PATCH 0/5] ceph: conversion to new netfs/fscache APIs
Date:   Fri, 20 Nov 2020 10:30:01 -0500
Message-Id: <20201120153006.304296-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patchset converts ceph to the new netfs/fscache APIs, and depends
on the fscache overhaul that David Howells recently posted. It also adds
support for writing to the cache. Due to the fact that we're leveraging
the new netfs_* helpers, this is substantial reduction in code as well.

I've tested this pretty extensively using xfstests and kernel builds,
both with and without the cache enabled. It all seems to do the right
thing now.

Jeff Layton (5):
  ceph: conversion to new fscache API
  ceph: convert readpage to fscache read helper
  ceph: plug write_begin into read helper
  ceph: convert ceph_readpages to ceph_readahead
  ceph: add fscache writeback support

 fs/ceph/Kconfig |   3 +-
 fs/ceph/addr.c  | 627 ++++++++++++++++++++++--------------------------
 fs/ceph/cache.c | 295 +++++++----------------
 fs/ceph/cache.h | 106 +++-----
 fs/ceph/caps.c  |  12 +-
 fs/ceph/file.c  |  14 +-
 fs/ceph/inode.c |  24 +-
 fs/ceph/super.c |   1 +
 fs/ceph/super.h |   1 -
 9 files changed, 450 insertions(+), 633 deletions(-)

-- 
2.28.0

