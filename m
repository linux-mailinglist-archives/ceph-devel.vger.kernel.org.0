Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDC01B0D07
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Apr 2020 15:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgDTNoi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Apr 2020 09:44:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726081AbgDTNoi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 20 Apr 2020 09:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587390277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=DeO1bWLn5C1PDseIUHBGmgkwOWAnibPK4fmDmUnKwZM=;
        b=JK2TRjtkgS4GlagtiHiC3GV3GqO0kV/3wDaQIV9bs9zpLrlhIUs1TCu3kPj53Y4kfpPhuO
        0Ll638iX47qnUKm0joFdG6ZgfHa8MACJCR6O2LwL32zBLj9sOBtE4dBwbQDlHh0xpM+Nep
        mvvVWKiMV1vGnU+KN5nRtx4YtNbIvJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-AsjRhcXENnGAptf90W0LEw-1; Mon, 20 Apr 2020 09:44:29 -0400
X-MC-Unique: AsjRhcXENnGAptf90W0LEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 804E2190A7A4
        for <ceph-devel@vger.kernel.org>; Mon, 20 Apr 2020 13:44:28 +0000 (UTC)
Received: from [10.3.128.3] (unknown [10.3.128.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FCEA58
        for <ceph-devel@vger.kernel.org>; Mon, 20 Apr 2020 13:44:27 +0000 (UTC)
Date:   Mon, 20 Apr 2020 13:44:25 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove myself as ceph co-maintainer 
Message-ID: <alpine.DEB.2.21.2004201343420.29831@piezo.novalocal>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff, Ilya, and Dongsheng are doing all of the Ceph maintainance
these days.

Signed-off-by: Sage Weil <sage@redhat.com>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b816a453b10e..7a691c8fc76d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3937,7 +3937,6 @@ F:        arch/powerpc/platforms/cell/
 CEPH COMMON CODE (LIBCEPH)
 M:     Ilya Dryomov <idryomov@gmail.com>
 M:     Jeff Layton <jlayton@kernel.org>
-M:     Sage Weil <sage@redhat.com>
 L:     ceph-devel@vger.kernel.org
 S:     Supported
 W:     http://ceph.com/
@@ -3949,7 +3948,6 @@ F:        net/ceph/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
 M:     Jeff Layton <jlayton@kernel.org>
-M:     Sage Weil <sage@redhat.com>
 M:     Ilya Dryomov <idryomov@gmail.com>
 L:     ceph-devel@vger.kernel.org
 S:     Supported
@@ -14096,7 +14094,6 @@ F:      drivers/media/radio/radio-tea5777.c
 
 RADOS BLOCK DEVICE (RBD)
 M:     Ilya Dryomov <idryomov@gmail.com>
-M:     Sage Weil <sage@redhat.com>
 R:     Dongsheng Yang <dongsheng.yang@easystack.cn>
 L:     ceph-devel@vger.kernel.org
 S:     Supported
-- 
2.24.1


