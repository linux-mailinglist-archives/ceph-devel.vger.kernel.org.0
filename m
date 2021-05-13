Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9979337F0F9
	for <lists+ceph-devel@lfdr.de>; Thu, 13 May 2021 03:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhEMBmY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 21:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhEMBmW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 21:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620870072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YFikn1S2PIWXBmKhZO071TxSVf87X6wWI0buV/JfQfk=;
        b=gL+ZuvLUaWLjWc+WXRKLPuq1MqYOosjauPgs2/I4GY688dWMOOr06SSipDMQmEutdT4qBK
        JF4HGYQ8ki38CLLMW24PrIc6P5MhzevU+esPGpEGd5kMFiIkf3Naaeo8doT05GIwLcAp5S
        ewqkn0yunBcE4Cu6WYjuwK4RODqD2NQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-QwY5ZXNfNjSbIEdDfY5LIA-1; Wed, 12 May 2021 21:41:09 -0400
X-MC-Unique: QwY5ZXNfNjSbIEdDfY5LIA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 108E61007476;
        Thu, 13 May 2021 01:41:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D5219D9F;
        Thu, 13 May 2021 01:41:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
Date:   Thu, 13 May 2021 09:40:51 +0800
Message-Id: <20210513014053.81346-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- change the patch order
- replace the fixed 10 with sizeof(struct ceph_metric_header)

Xiubo Li (2):
  ceph: simplify the metrics struct
  ceph: send the read/write io size metrics to mds

 fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
 fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
 2 files changed, 89 insertions(+), 80 deletions(-)

-- 
2.27.0

