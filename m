Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7767F36D206
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 08:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhD1GJg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 02:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhD1GJg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 02:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619590131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=53KquxinxQA9TOThnJbwPNSsJX9bBJn3qkBiMUKIYb8=;
        b=CQ8GA36cnLfiRTGmd5g9VWhMz105lP+GT/4GU9DCyxdTkl7U+ABEVUXStnv+iOi20NZlS1
        HV19QLw+p4NOOBYMa6mukC7cJloXdHGoWrTPU6ckjELCiE08BYAsqwsH0MaMNgR3chf0r0
        TExHzjAuWV0rQA8Pler6JoNkqh5hOh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-w9OHscggNd6GKS9-802ORg-1; Wed, 28 Apr 2021 02:08:46 -0400
X-MC-Unique: w9OHscggNd6GKS9-802ORg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C888F18B9F41;
        Wed, 28 Apr 2021 06:08:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED6086C32C;
        Wed, 28 Apr 2021 06:08:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: add IO size metric support
Date:   Wed, 28 Apr 2021 14:08:38 +0800
Message-Id: <20210428060840.4447-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V3:
- update and rename __update_latency to __update_stdev.

V2:
- remove the unused parameters in metric.c
- a small clean up for the code.

For the read/write IO speeds, will leave them to be computed in
userspace,
	where it can get a preciser result with float type.


Xiubo Li (2):
  ceph: update and rename __update_latency helper to __update_stdev
  ceph: add IO size metrics support

 fs/ceph/addr.c    | 14 +++++----
 fs/ceph/debugfs.c | 37 +++++++++++++++++++++---
 fs/ceph/file.c    | 23 +++++++--------
 fs/ceph/metric.c  | 74 ++++++++++++++++++++++++++++++++---------------
 fs/ceph/metric.h  | 10 +++++--
 5 files changed, 111 insertions(+), 47 deletions(-)

-- 
2.27.0

