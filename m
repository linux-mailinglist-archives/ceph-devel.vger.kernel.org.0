Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AD44C693
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Nov 2021 19:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhKJSDc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Nov 2021 13:03:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhKJSDb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 13:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636567243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VU9kxIX7z5fpmpmY6eWtdZnPEdlzxoqHRfL1nxepk9A=;
        b=HPNdXjOTdldnR0JjBlfLCeRUAJXcTBfb0h4U/iVZdYCfjo2GlxVH2sKR++YT8M45F7EmRD
        UOQJrFrez7ammMub/kkr4u6EhTTZ452dwX99OeFs6VDc1DFPfbcQTzhKqxNlbQHKOntnYl
        ZtDFbj4IhOFj8xzOEJToOdj1KejeVe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-jFr2alAeOIuWwB_VJUvv7Q-1; Wed, 10 Nov 2021 13:00:39 -0500
X-MC-Unique: jFr2alAeOIuWwB_VJUvv7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41A5B1023F53;
        Wed, 10 Nov 2021 18:00:38 +0000 (UTC)
Received: from fedora2.. (unknown [10.67.24.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B198196F1;
        Wed, 10 Nov 2021 18:00:24 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@redhat.com
Cc:     pdonnell@redhat.com, idryomov@gmail.com, xiubli@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v2 0/1] ceph: Fix incorrect statfs report
Date:   Wed, 10 Nov 2021 23:30:20 +0530
Message-Id: <20211110180021.20876-1-khiremat@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Kotresh HR <khiremat@redhat.com>

I have addressed the review comments.

For quota less than CEPH_BLOCK size, smaller block
size of 4K is used.

But if quota is less than 4K, it is decided to go
with binary use/free of 4K block. For quota size
less than 4K size, report the total=used=4K,free=0
when quota is full and total=free=4K,used=0 otherwise.

Kotresh HR (1):
  ceph: Fix incorrect statfs report for small quota

 fs/ceph/quota.c | 14 ++++++++++++++
 fs/ceph/super.h |  1 +
 2 files changed, 15 insertions(+)

-- 
2.31.1

