Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAFF108C9E
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 12:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKYLJA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 06:09:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727278AbfKYLJA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 06:09:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574680139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v2xz6CX1FKGDpr23zGt7SJWmWVRMbB6FjqN7nW5xry0=;
        b=e9owt5cAKFzJX0QFCdRXn0on1Xz/pW9YDqXoZK5fcHUTGE4WN3HK1unRQMvzpB6/t/EQb8
        irsdfmG4v+72C1LwTkxQiJ0wj0rG07V5snTDLNBWLRcl94TjjdznTRjTOGr86f65oi2C7Q
        qjVyElpBgKk6rl6poB/Wr7ssHwSeuMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-2cv7MOzsOGqAkhkJfAgfwQ-1; Mon, 25 Nov 2019 06:08:57 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF00B477;
        Mon, 25 Nov 2019 11:08:56 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F1535D9CA;
        Mon, 25 Nov 2019 11:08:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/3] mdsmap: fix mds choosing
Date:   Mon, 25 Nov 2019 06:08:24 -0500
Message-Id: <20191125110827.12827-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 2cv7MOzsOGqAkhkJfAgfwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- ignore laggy for the auth mds case
- for the random mds choosing, get one none laggy first and only
  when there has no we will fall back to choose a laggy one if there
  has.


Xiubo Li (3):
  mdsmap: add more debug info when decoding
  mdsmap: fix mdsmap cluster available check based on laggy number
  mdsmap: only choose one MDS who is in up:active state without laggy

 fs/ceph/mds_client.c        | 13 +++++--
 fs/ceph/mdsmap.c            | 74 ++++++++++++++++++++-----------------
 include/linux/ceph/mdsmap.h |  1 +
 3 files changed, 51 insertions(+), 37 deletions(-)

--=20
2.21.0

