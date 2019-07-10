Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062FC64A84
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfGJQL5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jul 2019 12:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbfGJQL4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 12:11:56 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89DCA2087F;
        Wed, 10 Jul 2019 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562775116;
        bh=ogzeWif3+hunxCJvyLma/tOxX24h+Akl4nhMVIqJwaA=;
        h=From:To:Cc:Subject:Date:From;
        b=tW4nuBWVj8w0ITvcP2ntAWgaQJp0LMSehqiutLnc9CAIofuEGgu6qGpr9bcU4ppfq
         2E1JUDb/9Esrfd9wMurdjepK7w3hQXgUMLmFYyoBLtix4fUXkGBkKGL0dYLQknLfn/
         ZEtKwd2ZAWrvU46SvyPQ2qdL6ncOauVnesgC5jqw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 0/3] ceph: fix races when uninlining data
Date:   Wed, 10 Jul 2019 12:11:51 -0400
Message-Id: <20190710161154.26125-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The current code that handles uninlining data is racy. The uninlining
and the update of i_inline_version are not well coordinated, so one task
could end up uninlining the data and then performing a write to the OSD
and then a second task could end up uninlining the data again and
clobber the first task's write.

The first couple of patches do a little cleanup of the uninlining helper
code, and then the last patch fixes the potential race.

Jeff Layton (3):
  ceph: make ceph_uninline_data take inode pointer
  ceph: pass unlocked page to ceph_uninline_data
  ceph: fix potential races in ceph_uninline_data

 fs/ceph/addr.c  | 57 +++++++++++++++++++++++++++----------------------
 fs/ceph/file.c  | 18 ++++++----------
 fs/ceph/super.h |  2 +-
 3 files changed, 39 insertions(+), 38 deletions(-)

-- 
2.21.0

