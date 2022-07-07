Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E607B569757
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Jul 2022 03:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiGGBUR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Jul 2022 21:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiGGBUQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Jul 2022 21:20:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF722E6A1
        for <ceph-devel@vger.kernel.org>; Wed,  6 Jul 2022 18:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657156815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XhRef+FkSZ+CxsMXJPxXaTYZ1wHLp5/yViMAXOga9OA=;
        b=YbZ6n/2FiIN14T4FP6ZQB3pGyEBtLbI2/CA5kNj0iqTWPqRQ7HNcGIA+jvACZqNtz/Js1A
        1wYCgo+7oGZ5Fqhg8Hzq3vEn8UQ5LPn5Q2QKxm5e+LxgrTKXyy67FSuLCSzSazR+4ldqxG
        WvwYI2DgQCFoFICAOB5WpztrL2FJFG4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-NV_AejODPiKvfs4BAytwIQ-1; Wed, 06 Jul 2022 21:20:13 -0400
X-MC-Unique: NV_AejODPiKvfs4BAytwIQ-1
Received: by mail-pf1-f200.google.com with SMTP id e21-20020aa78c55000000b00528c6cca624so642522pfd.3
        for <ceph-devel@vger.kernel.org>; Wed, 06 Jul 2022 18:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XhRef+FkSZ+CxsMXJPxXaTYZ1wHLp5/yViMAXOga9OA=;
        b=itMrhqh++iK58RnZxuPXgl2henXmNKg5GjDITxTKetalPRW6GakxVfhNEv4l9lTJaW
         S5Wj2/4YLJYSfxR+nYEvnFuIazJISFI0BhKGcMXt+an9YWOqvgqK8Xba3ohvKJdHrsWe
         QN1aMepkirK9Uk+qaRyWAcPvjFc9w33MEZWbN+tPwtcS1VsfcG25DevJnLNQjQTFbg9H
         pfSp76+lzTqBLHXVjVt1Lc26KJ00JApLo9TfFW8rZ+DEfe9BLUpor6BbG5tAQBqPwndD
         QVqhtwQ0b/8F9kD1f8XGFHOP6eObGnI7ggw0b5r0Gdmel47Z0MPjjWnx/4QUvHscn+UV
         dE6g==
X-Gm-Message-State: AJIora/RgNpoPjXvH9UyZqaSMh/fud2vG5IAFc5pyGqjudoJeuuvUM8I
        7hdALZDumWtFhrIdU+QJLAEoR9p8LtQtMwfLd6eJfvpSrpmLprxsgq7wwIimA+4U5IVSE0ZpwA0
        KuSrZkgouo+sNajAydnOdMg==
X-Received: by 2002:a17:902:7e8a:b0:16b:bc73:73bc with SMTP id z10-20020a1709027e8a00b0016bbc7373bcmr33191553pla.8.1657156812199;
        Wed, 06 Jul 2022 18:20:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vrNM1b0FLX4BeO8l5eCMZ8/8AxY6F5s6PSvYq0EjhOCrUEXjYTctmluydyxVAQfU3h9XB3/Q==
X-Received: by 2002:a17:902:7e8a:b0:16b:bc73:73bc with SMTP id z10-20020a1709027e8a00b0016bbc7373bcmr33191526pla.8.1657156811954;
        Wed, 06 Jul 2022 18:20:11 -0700 (PDT)
Received: from [10.72.12.227] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l15-20020a63da4f000000b0040d0a57be02sm24236158pgj.31.2022.07.06.18.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 18:20:11 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] fs/dcache: export d_same_name() helper
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jlayton@kernel.org, idryomov@gmail.com, viro@zeniv.linux.org.uk,
        willy@infradead.org, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220526011737.371483-1-xiubli@redhat.com>
 <20220526011737.371483-2-xiubli@redhat.com>
 <YsYFZU2Y2hkyVT3r@bombadil.infradead.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <36cb99e2-e612-0b85-8b7e-7d9cb02c2838@redhat.com>
Date:   Thu, 7 Jul 2022 09:20:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YsYFZU2Y2hkyVT3r@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/7/22 5:57 AM, Luis Chamberlain wrote:
> On Thu, May 26, 2022 at 09:17:36AM +0800, Xiubo Li wrote:
>> Compare dentry name with case-exact name, return true if names
>> are same, or false.
>>
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>
>    Luis

Thanks Luis!

-- Xiubo

>

