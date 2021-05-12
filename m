Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953C437B951
	for <lists+ceph-devel@lfdr.de>; Wed, 12 May 2021 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELJgA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 05:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELJf7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 05:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620812091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rtDztLwhDFInSAVGylZcT7UETsl2VSf87QEIzlbKTC4=;
        b=Y0eI1RCDsETp/qE7osnpRx+wO4Qsea94tXOdWGc+zXW5T0o+jFBO/WoC8cIW7RpNaBS2Ja
        lTJ4+YsTbneXp0pwe/clG/lMTxOh77R+c3kCZeLzT0jmApE2QBw5OCTLj44u5rWjUUhBEX
        e/iE17t1vF9yeuWw18ppYmY3cmTNrFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-HlEFEOB3NquGeFQhTM_KrA-1; Wed, 12 May 2021 05:34:49 -0400
X-MC-Unique: HlEFEOB3NquGeFQhTM_KrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A863107ACC7;
        Wed, 12 May 2021 09:34:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A85D25C232;
        Wed, 12 May 2021 09:34:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: send io size metrics to mds daemon
Date:   Wed, 12 May 2021 17:34:41 +0800
Message-Id: <20210512093443.35128-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (2):
  ceph: send the read/write io size metrics to mds
  ceph: simplify the metrics struct

 fs/ceph/metric.c | 89 ++++++++++++++++++++++++++++++------------------
 fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
 2 files changed, 88 insertions(+), 80 deletions(-)

-- 
2.27.0

