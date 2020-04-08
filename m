Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE521A23EF
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 16:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgDHOV2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 10:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgDHOV1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 10:21:27 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F313220780;
        Wed,  8 Apr 2020 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586355687;
        bh=qa/22M2Xka/ZWO0t6yeQTfWsKJpnxqhRjn8/Lipl4ec=;
        h=From:To:Cc:Subject:Date:From;
        b=iakLyXRdkYdBwKObhkdwHjwfJa0OM9tOLRz2tVygk8glVLnaCxhwUu+48AJ4ZKJzH
         t56CaXOME1RnYIq+1qDF38hSkUDJUWYj3fK4AMT8rwB9JsTTq8f/m0oDX/VcbkETof
         AJ2nmvt5chPBk9C8GyXdcKAE8ueGa+8Pp0Kcb9ng=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, dan.carpenter@oracle.com, sage@redhat.com
Subject: [PATCH 0/2] ceph: fix error handling bugs in async dirops callbacks
Date:   Wed,  8 Apr 2020 10:21:23 -0400
Message-Id: <20200408142125.52908-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This fixes a couple of problems that Dan spotted with a static checker.
Additionally the first patch also simplifies some of the error handling
in other callers.

Originally, I was going to squash these into the earlier patches that
introduced those bugs, but this is new code that isn't enabled by
default and Ilya was planning to a PR soon, so it's probably best to
just handle them as follow-on fixes to what's currently in
ceph-client/master.

Jeff Layton (2):
  ceph: have ceph_mdsc_free_path ignore ERR_PTR values
  ceph: initialize base and pathlen variables in async dirops cb's

 fs/ceph/debugfs.c    | 4 ----
 fs/ceph/dir.c        | 4 ++--
 fs/ceph/file.c       | 4 ++--
 fs/ceph/mds_client.c | 6 ++----
 fs/ceph/mds_client.h | 2 +-
 5 files changed, 7 insertions(+), 13 deletions(-)

-- 
2.25.2

