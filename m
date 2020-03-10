Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA817F658
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 12:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgCJLee (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 07:34:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39662 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726211AbgCJLee (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 07:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BF4wMg3VGGAHwdoOxvHYSEV2AiQAMjASG9qXdd82Ds4=;
        b=WQDbTAVFTWpeL3p58FpquRwJCKzf4Z9yoZ60u3wrlKfsiKKH7uCwaPc5iz9lrjWGsDX6s9
        1jXY0xPopDWtWl3o9XkOXz/VQlIMDg0cWLjoIRRee9Dp3b6rny6uMQl6rfG+7uHNaVmy7B
        2FyQLCLtg5M+YaveP05LshreoOTxDm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-XB6-3AgZNfW-qIoMMh80TQ-1; Tue, 10 Mar 2020 07:34:31 -0400
X-MC-Unique: XB6-3AgZNfW-qIoMMh80TQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B96B0107ACC4;
        Tue, 10 Mar 2020 11:34:26 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA62C5D9C5;
        Tue, 10 Mar 2020 11:34:24 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 0/4] fix ceph_get_caps() bugs
Date:   Tue, 10 Mar 2020 19:34:17 +0800
Message-Id: <20200310113421.174873-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Yan, Zheng (4):
  ceph: cleanup return error of try_get_cap_refs()
  ceph: request new max size only when there is auth cap
  ceph: don't skip updating wanted caps when cap is stale
  ceph: wait for async creating inode before requesting new max size

 fs/ceph/caps.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--=20
2.21.1

