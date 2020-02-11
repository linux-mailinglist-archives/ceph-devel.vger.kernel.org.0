Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D927715932B
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 16:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgBKPbu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 10:31:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729320AbgBKPbu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Feb 2020 10:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581435109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uXLnSaQF07b6MxmqqNLUnfPHd6pP4QaqXptooW+s8HA=;
        b=J4rxrGyMFsx6jBGf7lAijt2gQ0CI8tbm/scpdmnyhk5uELnqzEKYlgDoQbbKSx9Z8lO1Sl
        tD/zSok9xfuqsDIVVwlbG2whoUY9hd4Mt862jbm/A7ig3UuSWhG3mbTf0x/ckIm/b+20vd
        XAmV5Y+zIPK1Sn1P7RSCeHePqBbzWbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-1ho-v-lwPAWLy0isc_uERA-1; Tue, 11 Feb 2020 10:31:40 -0500
X-MC-Unique: 1ho-v-lwPAWLy0isc_uERA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E809477;
        Tue, 11 Feb 2020 15:31:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A0435C1B5;
        Tue, 11 Feb 2020 15:31:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: fix description of some mount options
Date:   Tue, 11 Feb 2020 10:31:20 -0500
Message-Id: <20200211153120.21369-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Based on the latest code, the default value for wsize/rsize is
64MB and the default value for the mount_timeout is 60 seconds.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Checked the history of the code, I am a little confused about the
default values for wsize/rsize, there never been 16MB as the default,
and for the mount_timeout, never seen 30 as default.

So did I miss something important about this ?


 Documentation/filesystems/ceph.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ceph.txt b/Documentation/filesyste=
ms/ceph.txt
index b19b6a03f91c..92ffc9b3b018 100644
--- a/Documentation/filesystems/ceph.txt
+++ b/Documentation/filesystems/ceph.txt
@@ -103,17 +103,17 @@ Mount Options
 	address its connection to the monitor originates from.
=20
   wsize=3DX
-	Specify the maximum write size in bytes.  Default: 16 MB.
+	Specify the maximum write size in bytes.  Default: 64 MB.
=20
   rsize=3DX
-	Specify the maximum read size in bytes.  Default: 16 MB.
+	Specify the maximum read size in bytes.  Default: 64 MB.
=20
   rasize=3DX
 	Specify the maximum readahead size in bytes.  Default: 8 MB.
=20
   mount_timeout=3DX
 	Specify the timeout value for mount (in seconds), in the case
-	of a non-responsive Ceph file system.  The default is 30
+	of a non-responsive Ceph file system.  The default is 60
 	seconds.
=20
   caps_max=3DX
--=20
2.21.0

