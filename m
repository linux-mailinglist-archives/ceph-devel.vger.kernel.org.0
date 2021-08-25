Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261F43F6EB5
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhHYFOs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhHYFOs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629868442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s2ekZy+Kl2eeq4uFtVAr/2Pcc39FUvtK9zsjJvOfzlc=;
        b=KDX8vHG10Jw8l2yTi+ANpe0YMa/UGN6APwIkvc8ojNKEqOCR62KBgdbshEOu0Fe4dCx4Rx
        SQUN1X5khcgq74ss31NPAp/YVHwkVRI89gEo9UBpi/buWqPG4Lt/DDHfjD7I24md/9ESeq
        SK8QsSVrx9K63p52GXB5nxlhEFnu9ik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-mbKiLS5uNjieQaQdzgJBfg-1; Wed, 25 Aug 2021 01:14:00 -0400
X-MC-Unique: mbKiLS5uNjieQaQdzgJBfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99B9F801A92;
        Wed, 25 Aug 2021 05:13:59 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73ADA18649;
        Wed, 25 Aug 2021 05:13:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/3] ceph: remove the capsnaps when removing the caps
Date:   Wed, 25 Aug 2021 13:13:52 +0800
Message-Id: <20210825051355.5820-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- minor fixes to clean up the code from Jeff's comments, thanks
- swith to use lockdep_assert_held().

Xiubo Li (3):
  ceph: remove the capsnaps when removing the caps
  ceph: don't WARN if we're force umounting
  ceph: don't WARN if we're iterate removing the session caps

 fs/ceph/caps.c       | 95 ++++++++++++++++++++++++++++++++------------
 fs/ceph/mds_client.c | 34 ++++++++++++++--
 fs/ceph/super.h      |  7 ++++
 3 files changed, 107 insertions(+), 29 deletions(-)

-- 
2.27.0

