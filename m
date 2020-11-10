Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12652AD435
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 11:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgKJK6L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 05:58:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbgKJK6L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 05:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605005890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nbFNHGWUSygEKEuDRoteRayu98iaK1xPwtyWNqq3F6s=;
        b=Mejc+TgZ3Y/RP4+HqmcV6qoPOaBT48GnUPfCbSIDqQVhk0K0CgTfx/szBXgeoxtwvn1nDu
        HE23Qftc9R78d6yAsAgkMzL4CN25EZMSCUbhj8rh6Zm+QwWrtml2G/e85NCy5OrDXAEk+2
        n2elwHxWv0BW8D/VUMiybBIzzRZl0t4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-EUqiEbqgO1K2dzz1p9qxag-1; Tue, 10 Nov 2020 05:58:07 -0500
X-MC-Unique: EUqiEbqgO1K2dzz1p9qxag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96A15804751;
        Tue, 10 Nov 2020 10:58:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D0C75138;
        Tue, 10 Nov 2020 10:58:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: add _IDS ioctl cmd and status debug file support
Date:   Tue, 10 Nov 2020 18:57:53 +0800
Message-Id: <20201110105755.340315-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- some typo fixings
- switch to use ceph_client_gid() and ceph_client_addr() helpers
- for ioctl cmd will return in text for cluster/client ids

Xiubo Li (2):
  ceph: add status debug file support
  ceph: add CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS ioctl cmd support

 fs/ceph/debugfs.c | 20 ++++++++++++++++++++
 fs/ceph/ioctl.c   | 23 +++++++++++++++++++++++
 fs/ceph/ioctl.h   | 15 +++++++++++++++
 fs/ceph/super.h   |  1 +
 4 files changed, 59 insertions(+)

-- 
2.27.0

