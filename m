Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4015479A9
	for <lists+ceph-devel@lfdr.de>; Sun, 12 Jun 2022 11:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbiFLJtT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Jun 2022 05:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiFLJtR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 12 Jun 2022 05:49:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6631B1A3BA
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655027352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ueojtz1qJqSwNeDQ6G0NW62ZJmgzyPTJLtBXSIbEn8=;
        b=XGbtR24ZyakyPVh15tPDLou3HndTJcyTaQhgrKEy6djLihdAaqwY3vEHMYz5YWDihq41Px
        KTBusAOwwcem+T2c6Xz/as6SWyra7ayQmaENUk0ksjgcD9J1ytfi0qmB3MVvS2Ekuru0tt
        sbBqwLDKc1969pMlhzr+dbpL3KEdOBo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-IIaWSkV_PIiHCXFqv7Gvig-1; Sun, 12 Jun 2022 05:49:11 -0400
X-MC-Unique: IIaWSkV_PIiHCXFqv7Gvig-1
Received: by mail-pj1-f72.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so4366598pjb.2
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 02:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8ueojtz1qJqSwNeDQ6G0NW62ZJmgzyPTJLtBXSIbEn8=;
        b=CadbMePkZrqKgvVUjftgAxW0SAmFA4mSTswCw8n1mVmeuqRCFRmVu5GDp58TUi39/f
         9/iCcYgZSEE6uVKPwYDdMHJ68BmEpTwLu/dSIUzdXQEAlEyOhb4QgyUejBcl6fUvT0t4
         34Dflpv2ebc3RYaMbM+nedcY3vpJa6lzwNHJ8wE7TVFnOnG0sSPmRL2k6U/oKjPePghM
         rHxa6T2yZ/9hlNKYc++TyP2N+xAjO9OaN8P4oPgiZ5Y9/KGNj5Pks6ZKpGPDji7qrPfM
         LbAY2WoHcUzaZQIs14uoPxktt4scCjrlUqD4Y1BX1lH0hYMjBvL4dp3ow6PX7nGisGJd
         cdyg==
X-Gm-Message-State: AOAM533mlmJhueo8h0kWSIEoUgfLAz3Sds3UaTxUiOUDqVTdxj+zW4xU
        uatFvd+J9xXor6WhYwDVxLLuKShRcglJ8ijFwGvcWX1msXwNyOYMqARwm21jjGEo61sMfbYFaIP
        A4oaCVX/wU5KMr1o4hI9v4g==
X-Received: by 2002:a63:2447:0:b0:3fd:b97e:7f0f with SMTP id k68-20020a632447000000b003fdb97e7f0fmr31143274pgk.516.1655027349343;
        Sun, 12 Jun 2022 02:49:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcU12zPAvIpmwm6g1gCPwF4wDI9URXG1GESIcb7MpnxC6rNtnvCuoRlZonmT1LwZLFoxmCIQ==
X-Received: by 2002:a63:2447:0:b0:3fd:b97e:7f0f with SMTP id k68-20020a632447000000b003fdb97e7f0fmr31143263pgk.516.1655027349074;
        Sun, 12 Jun 2022 02:49:09 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mi16-20020a17090b4b5000b001e0c1044ceasm2794010pjb.43.2022.06.12.02.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 02:49:08 -0700 (PDT)
Subject: Re: [PATCH] ceph: switch back to testing for NULL folio->private in
 ceph_dirty_folio
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <20220610154013.68259-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <987101f4-3d93-3a8b-1a89-a63644523f48@redhat.com>
Date:   Sun, 12 Jun 2022 17:49:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220610154013.68259-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/10/22 11:40 PM, Jeff Layton wrote:
> Willy requested that we change this back to warning on folio->private
> being non-NULl. He's trying to kill off the PG_private flag, and so we'd
> like to catch where it's non-NULL.
>
> Add a VM_WARN_ON_FOLIO (since it doesn't exist yet) and change over to
> using that instead of VM_BUG_ON_FOLIO along with testing the ->private
> pointer.
>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c          | 2 +-
>   include/linux/mmdebug.h | 9 +++++++++
>   2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index b43cc01a61db..b24d6bdb91db 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>   	 * Reference snap context in folio->private.  Also set
>   	 * PagePrivate so that we get invalidate_folio callback.
>   	 */
> -	VM_BUG_ON_FOLIO(folio_test_private(folio), folio);
> +	VM_WARN_ON_FOLIO(folio->private, folio);
>   	folio_attach_private(folio, snapc);
>   
>   	return ceph_fscache_dirty_folio(mapping, folio);
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index d7285f8148a3..5107bade2ab2 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -54,6 +54,15 @@ void dump_mm(const struct mm_struct *mm);
>   	}								\
>   	unlikely(__ret_warn_once);					\
>   })
> +#define VM_WARN_ON_FOLIO(cond, folio)		({			\
> +	int __ret_warn = !!(cond);					\
> +									\
> +	if (unlikely(__ret_warn)) {					\
> +		dump_page(&folio->page, "VM_WARN_ON_FOLIO(" __stringify(cond)")");\
> +		WARN_ON(1);						\
> +	}								\
> +	unlikely(__ret_warn);						\
> +})
>   #define VM_WARN_ON_ONCE_FOLIO(cond, folio)	({			\
>   	static bool __section(".data.once") __warned;			\
>   	int __ret_warn_once = !!(cond);					\

All tests passed except the known issues.

Merged into testing branch, thanks Jeff!

-- Xiubo


