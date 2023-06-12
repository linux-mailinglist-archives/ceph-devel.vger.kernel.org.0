Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FC72CA07
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 17:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbjFLP1Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbjFLP1O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 11:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB5010CC
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 08:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686583577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ts8591bNQt9tpzTps1sWVDQKmLYik3H7SXXmdaag3qE=;
        b=UpnNhkVacSN0U4HczbWcIB4LU+BwuakxlkcljUKWTDVALKuor8rze1SYj6fd7dnjvjgOxI
        JmSHlB0H0cp/TndkylmaD18IEY+7h0veva157O+D3lfRNcVAhsJSk4FIn7v4w2AMen/Omh
        SW+6J96cKBEmsZp6q+ewweVdHcBcgak=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-xzjB62d4NMWpan5ocMJmXg-1; Mon, 12 Jun 2023 11:26:16 -0400
X-MC-Unique: xzjB62d4NMWpan5ocMJmXg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6260b40eac6so25646d6.0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 08:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686583576; x=1689175576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ts8591bNQt9tpzTps1sWVDQKmLYik3H7SXXmdaag3qE=;
        b=HuwOyFQf3KpEV22sc5xC+R/LeNFwRs8xJWsf4DC5X3mh7KhpeZVtcLPOhZDTcsmrme
         AOQzeWAc1auGObgm+RCj4G+ezIub/vBwAzhoQ1P8glUZ6M0flnowomhD9pixqgy175bZ
         RHuece++qfw8od37GiJBhpFNOVMiV4g99hBLL7Jz03kT/xjfsOHDzff1ZC0Ix9MMX1TO
         H9BtqK3SwlZieNraAJ7GzlcBcMkgGUzSu+LNNwerTNktKzaHEQE35Q4yQwWwINamqkp6
         O9Q4RnnuVSSQ42HJL2vWbtKlh7Q3te3rXlLU838DRyayoB3uCUYmwnFAYwarPI0LxqSA
         MFhg==
X-Gm-Message-State: AC+VfDwx9+aVH10dilHaPEVJlBV40fhIKBcjAPUNCgVFsit8j8Iudxrr
        01kPVR6thTUWc95YmY8C5iENl9Fr/i/zps4xLziVTgK0fhQ3KrxjS/2p2yML8Pn8kFqlW6Sn+GA
        /OMYOzY8K+umoP81YzbSGTHu9LJzKDI1pUOs6hA==
X-Received: by 2002:a05:6214:2589:b0:623:7108:362d with SMTP id fq9-20020a056214258900b006237108362dmr10296528qvb.9.1686583575937;
        Mon, 12 Jun 2023 08:26:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+/mZ7EAagnWdVy0mSQSFZhUJ3i4DBavpg5LtDMaJfaG1KdIcGxOYDFsR0P+MGYVGmaXmdP34bjU66RUO4GLM=
X-Received: by 2002:a05:6214:2589:b0:623:7108:362d with SMTP id
 fq9-20020a056214258900b006237108362dmr10296506qvb.9.1686583575544; Mon, 12
 Jun 2023 08:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230612114359.220895-1-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-1-xiubli@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 12 Jun 2023 11:25:49 -0400
Message-ID: <CA+2bHPZUysbfZfWE6FPgbvsbv_3T4mN+bgOeR-ShDzg6OHfx7w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] ceph: print the client global id for debug logs
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>

