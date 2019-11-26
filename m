Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9521E109DDF
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 13:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfKZMYl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 07:24:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39751 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728290AbfKZMYl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 07:24:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574771080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6i/TtNALGn7GYWCRK4qqpJcbqliPeiQT5Yp7Ud4ayT4=;
        b=e4tflmBHotWvCw+E+1jYiwFUCMDut/ezEsVCUbTaR7QSLq7Xj78WQZcRj+IYvF0l0fShnK
        tFWSWjzMQjkYo73OSFYX2XfXzRtuwNO6U6hTDlNoOpyTLra45kiIk5NhNMnd6NVur5irYO
        iOW4dQ8aDz5VYi4jHt3J/3nKDjKD0V4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-vohFnVZBMiqPlhl_VlyQKw-1; Tue, 26 Nov 2019 07:24:39 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 915C71800D6A;
        Tue, 26 Nov 2019 12:24:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 393F35D6BE;
        Tue, 26 Nov 2019 12:24:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, zyan@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/3] mdsmap: fix mds choosing
Date:   Tue, 26 Nov 2019 07:24:19 -0500
Message-Id: <20191126122422.12396-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: vohFnVZBMiqPlhl_VlyQKw-1
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

V3:
- add the mds sanity check

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

