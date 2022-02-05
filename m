Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4094AAC4F
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Feb 2022 20:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351321AbiBETgY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 5 Feb 2022 14:36:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbiBETgY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 5 Feb 2022 14:36:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644089784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GmMKdCNjwZQVlmwMkZuhODZ7bWcnlhuXVRcHRGYou7U=;
        b=Y+UGMJpXltr9yOuWzxC7wSXxBy93YuS+LIwhmgrW9WJIOO1ZAgT6afEweuP+xZqF/U4hQj
        cjsmqpp2AtY9l7hbGGLvV0Txm1Zhu7YugD/JrGCf3HrY456pFDW0bzAtOs7ZtSAZp8xv8S
        //RSKHWt8Dju99OPMRM0RtrdFStkAqA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-3dZG1sFSNSuyi38Ts8aXQg-1; Sat, 05 Feb 2022 14:36:22 -0500
X-MC-Unique: 3dZG1sFSNSuyi38Ts8aXQg-1
Received: by mail-io1-f71.google.com with SMTP id b4-20020a05660214c400b00632eb8bff25so6005353iow.1
        for <ceph-devel@vger.kernel.org>; Sat, 05 Feb 2022 11:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GmMKdCNjwZQVlmwMkZuhODZ7bWcnlhuXVRcHRGYou7U=;
        b=rywJDbvo8djq7+XyNJpmDRQIzrS8bGqCm14tSwmuWErCUg9O4zSSqCRfkWvRegzt8N
         PFOVkhSCNlpo46S84Hk6z2yFp8U5pKwHIA6JZKYDlw5JIUrj85mowvjNYYjPtCxLxJF7
         OO42X7BDXCGCMoXXOIa7V7I79zU4iORQuEBKRTN7p1dY5Ze4fEKVQIGdEejBSsQT72oA
         /4MhV0QTKK6A1oAkBcrZsLgNxIsh8kmDAkZrMY9TglfqKz4m3GAwM0iRfqh7EDqmZOS7
         eI+OOjjBaEjPJ0G47QywcxcczmU4tjjY9fc4YYqBFNRLwsKUCfxMQRFOgoNaiDqODVcU
         aQGQ==
X-Gm-Message-State: AOAM531dYf2khbQMi8jMTakGoDCaNTpom1DdLyhgNLfDv0z7OOoMISw8
        GTn2mVVCroqvM7ylQIOkKZdm4U4srB7mED0E4/+DfUUbuoy6rltistFqQmLwSxa15y3CSXtug0v
        4RFR6hTu9pRtyZSnRImB1I7aLPCC3bZesRTlpWA==
X-Received: by 2002:a05:6638:d06:: with SMTP id q6mr2363295jaj.197.1644089782223;
        Sat, 05 Feb 2022 11:36:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwva5MZSyNFPHm+ZNvKxYfkkdvW3ChBcxatiEPlYagt6rSeN1AQyRrq0ksc6RlGGNQTXhjTsVCnJ85xXQSUDWg=
X-Received: by 2002:a05:6638:d06:: with SMTP id q6mr2363290jaj.197.1644089782057;
 Sat, 05 Feb 2022 11:36:22 -0800 (PST)
MIME-Version: 1.0
References: <20220205151705.36309-1-jlayton@kernel.org>
In-Reply-To: <20220205151705.36309-1-jlayton@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Sat, 5 Feb 2022 14:35:56 -0500
Message-ID: <CA+2bHPaJFM=3TuDZK9phLUWRvktBkLTPQZDaPFSPZ30WJYU0jQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: wait for async create reply before sending any cap messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

