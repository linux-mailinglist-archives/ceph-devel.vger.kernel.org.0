Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13DC348781
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Mar 2021 04:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhCYD3H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 23:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhCYD2x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 23:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616642932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aP9C8cuD0os1GVGVfxQ7w3LIUMBKItpG18MEBJS8lhc=;
        b=Ll7sGoAznCF7xnSGmONF2cY2PCk0wX+zOwVBgbGwcZbGJ0OXcusTH6KRkUBDzFER93Zef7
        6dzABY9wx9EirgXOXKbC4Weft78F4zbwnJLFWJP3//nxVtCW9Qh2JNoX0zL5Z1Kbi2SwAE
        KYOGiFPlufELtDC8Klmj3ip945k2W3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-pUhy0oAkPFC_W5n3KmWYnA-1; Wed, 24 Mar 2021 23:28:49 -0400
X-MC-Unique: pUhy0oAkPFC_W5n3KmWYnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96393180FCA0;
        Thu, 25 Mar 2021 03:28:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59A9862951;
        Thu, 25 Mar 2021 03:28:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: add IO size metric support
Date:   Thu, 25 Mar 2021 11:28:24 +0800
Message-Id: <20210325032826.1725667-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- remove the unused parameters in metric.c
- a small clean up for the code.

For the read/write IO speeds, will leave them to be computed in userspace,
where it can get a preciser result with float type.


Xiubo Li (2):
  ceph: update the __update_latency helper
  ceph: add IO size metrics support

 fs/ceph/addr.c    |  14 +++---
 fs/ceph/debugfs.c |  37 ++++++++++++++--
 fs/ceph/file.c    |  23 +++++-----
 fs/ceph/metric.c  | 109 ++++++++++++++++++++++++++++++++++++----------
 fs/ceph/metric.h  |  10 ++++-
 5 files changed, 146 insertions(+), 47 deletions(-)

-- 
2.27.0

