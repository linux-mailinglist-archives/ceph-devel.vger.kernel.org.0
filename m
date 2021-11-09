Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA20944AA57
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 10:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244750AbhKIJOe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 04:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244919AbhKIJN4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Nov 2021 04:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636449070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IBfLVbLEOnuc4KwtPsEUDbqA444qcEpMGr2LcGZBgz4=;
        b=b3td0cHLnYFez+FP7muI6dgMlyH8ARrS5B9wE54lHwyGdR7B9nvvboX/RlYE9KbLYeCJw0
        77MoSGu6OkkEpTq0U8TGI21+z0kKJBaXQciIoYUJG58M/ysCa2PavZTefNc+TxlBAIMv9w
        hei1JHur21608pA+rTJHpAbecoC5zlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-jB7TyweXMLuBfQoOmtph_w-1; Tue, 09 Nov 2021 04:11:06 -0500
X-MC-Unique: jB7TyweXMLuBfQoOmtph_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F17E1098BC1;
        Tue,  9 Nov 2021 09:10:46 +0000 (UTC)
Received: from kotresh-T490s.redhat.com (unknown [10.67.24.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7CE19C59;
        Tue,  9 Nov 2021 09:10:43 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v1 0/1] ceph: Fix incorrect statfs report
Date:   Tue,  9 Nov 2021 14:40:40 +0530
Message-Id: <20211109091041.121750-1-khiremat@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Kotresh HR <khiremat@redhat.com>

The statfs reports incorrect free/available space
for quota less then CEPH_BLOCK size (4M).

The approach chosen is to go with binary use/free
of full block instead of chosing the smaller block
size.

For quota size less than CEPH_BLOCK size, report
the total=used=CEPH_BLOCK,free=0 when quota is
full and total=free=CEPH_BLOCK, used=0 otherwise.

Kotresh HR (1):
  ceph: Fix incorrect statfs report for small quota

 fs/ceph/quota.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
2.31.1

