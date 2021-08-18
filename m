Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DBC3EFEA3
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 10:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbhHRIGq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 04:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239835AbhHRIGp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 04:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629273970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0H4enCSvCD5BGsA3s19ZZ+GEZbzo/fg2Ym/1DcMsCK8=;
        b=YFMnwrrn76GpBKqzz7HUFdqCXkHytyXSwb4oB9PVPZ3osJ2LSywXvhR2O4D/dTty+eol4S
        Zpd1c18X1EahWHnNUnWNrHW4cPqji6ftzTmJQUaaAJGdaE7ISIZ2NAU/DTCTjHh8vgU/CK
        lY+3cbYJQ0I5+VEcdAapvw1EFxLWVH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-DR71qxMEPVqFMfPL0aBY9Q-1; Wed, 18 Aug 2021 04:06:09 -0400
X-MC-Unique: DR71qxMEPVqFMfPL0aBY9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A6051082925;
        Wed, 18 Aug 2021 08:06:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 239415C232;
        Wed, 18 Aug 2021 08:06:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] ceph: remove the capsnaps when removing the caps
Date:   Wed, 18 Aug 2021 16:06:00 +0800
Message-Id: <20210818080603.195722-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Fix the memory leak for the ceph_inode_info and two warnings.


Xiubo Li (3):
  ceph: remove the capsnaps when removing the caps
  ceph: don't WARN if we're force umounting
  ceph: don't WARN if we're iterate removing the session caps

 fs/ceph/caps.c       | 62 ++++++++++++++++++++++++++++----------------
 fs/ceph/mds_client.c | 36 +++++++++++++++++++++----
 fs/ceph/super.h      |  6 ++++-
 3 files changed, 75 insertions(+), 29 deletions(-)

-- 
2.27.0

