Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C60974CBC
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403922AbfGYLRu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403888AbfGYLRs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:48 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E652D2238C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053468;
        bh=bat/TqxwOJPCwH6TZIsVjeElGTxA3fplVkwscdQ/wC8=;
        h=From:To:Subject:Date:From;
        b=H1ua68amx1tTKk2hl9m1p16pQhAYMHQXAIMtQ5cU6Hpb+2KxKQ7ywm1FjMgK2oSHs
         Ae78zyub2121Du9kqhgTLO3689WNgGHU7IF8byyMcY1cN9i5SZ/vaGuFREQPItv+5n
         aGN/veXiGJp33q+hUgpWt2liPJNfFoyQ8za92TDw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 0/8] ceph: minor cleanup patches for v5.4
Date:   Thu, 25 Jul 2019 07:17:38 -0400
Message-Id: <20190725111746.10393-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've been trying to chip away at the coverage of the session->s_mutex,
and in the process have been doing some minor cleanup of the code and
comments, mostly around the cap handing.

These shouldn't cause much in the way of behavioral changes.

Jeff Layton (8):
  ceph: remove ceph_get_cap_mds and __ceph_get_cap_mds
  ceph: fetch cap_gen under spinlock in ceph_add_cap
  ceph: eliminate session->s_trim_caps
  ceph: fix comments over ceph_add_cap
  ceph: have __mark_caps_flushing return flush_tid
  ceph: remove unneeded test in try_flush_caps
  ceph: remove CEPH_I_NOFLUSH
  ceph: remove incorrect comment above __send_cap

 fs/ceph/caps.c       | 80 ++++++++++++--------------------------------
 fs/ceph/mds_client.c | 17 +++++-----
 fs/ceph/mds_client.h |  2 +-
 fs/ceph/super.h      | 20 +++++------
 4 files changed, 39 insertions(+), 80 deletions(-)

-- 
2.21.0

