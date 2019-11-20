Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023A41035F7
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 09:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfKTI3R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 03:29:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726038AbfKTI3R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 03:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574238556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D1zwNt4ngJ7x+SdZ0pUUggxn+URxq699gZkKrBLoR9k=;
        b=VgobCxzGdPzysGKxpF7WzKt7Ecv8VPlBh+2JKxz0vo5V8AQZKHJ2IIED/p6J9ME7I7kJRN
        ahGb3ysPoTtAkSyAfJg2cef31a4SEqak6ootTB5r6c4ZVYw+axK9ZSx6xTV6P+X0YDlRve
        zkRxEnoS0OeGI/C1dOqRnFRLHtW1xBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-CmlccGDyPCuZmO2SC34UJw-1; Wed, 20 Nov 2019 03:29:13 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 064821005513;
        Wed, 20 Nov 2019 08:29:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDCF867E52;
        Wed, 20 Nov 2019 08:29:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] mdsmap: fix mds choosing
Date:   Wed, 20 Nov 2019 03:28:59 -0500
Message-Id: <20191120082902.38666-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: CmlccGDyPCuZmO2SC34UJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (3):
  mdsmap: add more debug info when decoding
  mdsmap: fix mdsmap cluster available check based on laggy number
  mdsmap: only choose one MDS who is in up:active state without laggy

 fs/ceph/mds_client.c |  6 ++++--
 fs/ceph/mdsmap.c     | 27 ++++++++++++++++++---------
 2 files changed, 22 insertions(+), 11 deletions(-)

--=20
2.21.0

