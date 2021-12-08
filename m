Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B776B46D388
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Dec 2021 13:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhLHMtR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Dec 2021 07:49:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231921AbhLHMtP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Dec 2021 07:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638967543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ex/4WkqoixdZ6NJEQXLDd8egmx8sj8pSuVIEx3yEHPY=;
        b=NnmhTfY34iORiS2a9Plp2AfBsDsuZ6ye57U047X724uK/ti0LEvuwKmnrNmz5CA517YXqu
        woTidpsZ+JnSS1RF8jAZuym++/u5GmysRiSxuZmciWP2AolTQ8/WaLe38QdvekFAN/pOlg
        C0BO3Ur4I6oOzSl1i8gq6Bzkz7GrGT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-jiZNM6eVOBq69Xvz9nWZNw-1; Wed, 08 Dec 2021 07:45:42 -0500
X-MC-Unique: jiZNM6eVOBq69Xvz9nWZNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C70F8042F9;
        Wed,  8 Dec 2021 12:45:41 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E30660BF1;
        Wed,  8 Dec 2021 12:45:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 0/9]  ceph: size handling for the fscrypt
Date:   Wed,  8 Dec 2021 20:45:26 +0800
Message-Id: <20211208124528.679831-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V7:
- Use the u64 instead of object version struct.


Changed in V6:
- Fixed the file hole bug, also have updated the MDS side PR.
- Add add object version support for sync read in #8.


Xiubo Li (2):
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt

 fs/ceph/crypto.h |  21 +++++
 fs/ceph/file.c   |   8 +-
 fs/ceph/inode.c  | 223 +++++++++++++++++++++++++++++++++++++++++++----
 fs/ceph/super.h  |   8 +-
 4 files changed, 242 insertions(+), 18 deletions(-)

-- 
2.27.0

