Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDC23440F5
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Mar 2021 13:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCVM3W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Mar 2021 08:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhCVM3B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616416140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=It1kvv5K9906cQQLtCqcltVMwricNmawaIa6KWMZKWw=;
        b=brjHwlV240BtnwkTKpSzhTnuk+iCCaVxd+MVeprQ7zmlW5rkkRa59v9Z165qOpmryDloCU
        tuP3L0VA//9RcHzr2LMa7efTd8++xelr9StHPaoAGvGJKei+6utBToAAQ9M21eg88X3TxC
        blseAkq4y5fAdfEcnV+aOXM1qhGSvYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-MVVmsxMVNFut3etQuy_ong-1; Mon, 22 Mar 2021 08:28:58 -0400
X-MC-Unique: MVVmsxMVNFut3etQuy_ong-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53AF8A0CA0;
        Mon, 22 Mar 2021 12:28:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C4AE1C4;
        Mon, 22 Mar 2021 12:28:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/4] ceph: add IO size metric support
Date:   Mon, 22 Mar 2021 20:28:48 +0800
Message-Id: <20210322122852.322927-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Currently it will show as the following:

item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
----------------------------------------------------------------------------------------
read          1           10240           10240           10240           10240
write         1           10240           10240           10240           10240



Xiubo Li (4):
  ceph: rename the metric helpers
  ceph: update the __update_latency helper
  ceph: avoid count the same request twice or more
  ceph: add IO size metrics support

 fs/ceph/addr.c       |  20 +++----
 fs/ceph/debugfs.c    |  49 +++++++++++++----
 fs/ceph/file.c       |  47 ++++++++--------
 fs/ceph/mds_client.c |   2 +-
 fs/ceph/metric.c     | 126 ++++++++++++++++++++++++++++++++-----------
 fs/ceph/metric.h     |  22 +++++---
 6 files changed, 184 insertions(+), 82 deletions(-)

-- 
2.27.0

