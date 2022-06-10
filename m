Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7A545B1F
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 06:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiFJEcC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 00:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiFJEb7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 00:31:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D16E4B1CB
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 21:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654835516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IzDVNxJil1JPXDr8fY17/GfAAmN3vGiE+AU0RsyQRsI=;
        b=OACxCK3j6rX+WKbiqzXgNmuPPkJQGkoAGsUsUxNODUf+83rZeHtuP/CrYnaSIHgtjMsI9b
        UWfF4UwU4GGj75JYDSGcqncL0wSFOiZMl86VV0VmhskUyMMkh0cVC9pmYciOcdu8Xbx2hV
        qtYT9BJquh42yzmKKIHm60K9Ry6SQuY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-C__zc8VwPE6jMhEuqROwVw-1; Fri, 10 Jun 2022 00:31:49 -0400
X-MC-Unique: C__zc8VwPE6jMhEuqROwVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A11185A7A4;
        Fri, 10 Jun 2022 04:31:49 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD2012026D64;
        Fri, 10 Jun 2022 04:31:48 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: update the auth cap when the async create req is forwarded
Date:   Fri, 10 Jun 2022 12:31:38 +0800
Message-Id: <20220610043140.642501-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Xiubo Li (2):
  ceph: make change_auth_cap_ses a global symbol
  ceph: update the auth cap when the async create req is forwarded

 fs/ceph/caps.c       |  4 +--
 fs/ceph/file.c       | 12 +++++++++
 fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/super.h      |  4 +++
 4 files changed, 76 insertions(+), 2 deletions(-)

-- 
2.36.0.rc1

