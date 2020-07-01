Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAFF210FD8
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgGAPyu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 11:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732241AbgGAPys (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 11:54:48 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FF2207BB;
        Wed,  1 Jul 2020 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593618887;
        bh=t2Y+MlFY8Lj8P6L7uPF1KpYeBMWLeFcy2Myf+XIOd7w=;
        h=From:To:Cc:Subject:Date:From;
        b=XHX101GqPk5+NNKIf0iGFs4JP+tiJ/DB5uxh5dJ2d2/zDrzJdVkGGYh0Qss8iPOOs
         Cek+iCT1zRhIti6mvKnXMT+1R/kFpsI++/Y5f1F36txqRoKlGyRmWrfbYVgnOBxDXM
         9sF+4CaaZG0yZZW+cOg0nBmU1ESaru6aRoXM58AM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH 0/4] libceph/ceph: cleanups and move more into ceph.ko
Date:   Wed,  1 Jul 2020 11:54:42 -0400
Message-Id: <20200701155446.41141-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is just a small set of cleanups, with a final patch that moves a
chunk of cephfs-specific code out of libceph.ko and into ceph.ko. There
should be no functional changes here.

Jeff Layton (4):
  libceph: just have osd_req_op_init return a pointer
  libceph: refactor osdc request initialization
  libceph: rename __ceph_osdc_alloc_messages to ceph_osdc_alloc_num_messages
  libceph/ceph: move ceph_osdc_new_request into ceph.ko

 fs/ceph/Makefile                |   2 +-
 fs/ceph/addr.c                  |   1 +
 fs/ceph/file.c                  |   1 +
 fs/ceph/osdc.c                  | 113 +++++++++++++++++++
 fs/ceph/osdc.h                  |  16 +++
 include/linux/ceph/osd_client.h |  19 ++--
 net/ceph/osd_client.c           | 185 ++++++--------------------------
 7 files changed, 173 insertions(+), 164 deletions(-)
 create mode 100644 fs/ceph/osdc.c
 create mode 100644 fs/ceph/osdc.h

-- 
2.26.2

