Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3F2A7594
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Nov 2020 03:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgKEChM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Nov 2020 21:37:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgKEChM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Nov 2020 21:37:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604543831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iW3bz7sqw+LAsvJxKOSUGHH9FuhRYQ3snCFyOMwoHqM=;
        b=Icf4iFF71MEnOrxL1hnb02u7frv9HxmAgi3FHu21xPyozshH2rmGM4XPaRfHdUfB/uwaS/
        hdGErtFOZXFkcTvNUUWpYVSyPscK3afVvVOuCqHhillyo9d0qGdSOxxnx2fkBbK/W3S2Co
        fFimSyukIYs/vSaYGbwCDPDnni+CPkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-ahBOZHwbN3CdI_vrydmkzg-1; Wed, 04 Nov 2020 21:37:09 -0500
X-MC-Unique: ahBOZHwbN3CdI_vrydmkzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D4E11074643;
        Thu,  5 Nov 2020 02:37:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-120.gsslab.pek2.redhat.com [10.72.37.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 346875D994;
        Thu,  5 Nov 2020 02:37:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2]  ceph: add _IDS ioctl cmd and status debug file support
Date:   Wed,  4 Nov 2020 21:37:01 -0500
Message-Id: <20201105023703.735882-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (2):
  ceph: add status debug file support
  ceph: add CEPH_IOC_GET_FS_CLIENT_IDS ioctl cmd support

 fs/ceph/debugfs.c | 22 ++++++++++++++++++++++
 fs/ceph/ioctl.c   | 22 ++++++++++++++++++++++
 fs/ceph/ioctl.h   | 15 +++++++++++++++
 fs/ceph/super.h   |  1 +
 4 files changed, 60 insertions(+)

-- 
2.18.4

