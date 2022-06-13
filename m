Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483FE547D26
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiFMAsw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Jun 2022 20:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiFMAsv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 12 Jun 2022 20:48:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A122812D07
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 17:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655081327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVb+7zvjVPzPZa4Ju8Hh8oEGpXymYillvQMsMLxa+2o=;
        b=gXX7l83+xpDkFItpS4hJCNYdGVF6yuhvLi6+c4uxQomH9UzVnZWPYb4c5Y42iUM9s8S7a1
        lKh+yTWO/wCN/I03tZmfaT20IQAG1+RHEFGTGyULlJ53rLRIrxHpJhnXM503fnU1E72zTP
        6bjlQFnXZ5hOLhbVHNScyGOMKa6y4yE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-h5CVNPg7O1CRqIlytbL57Q-1; Sun, 12 Jun 2022 20:48:46 -0400
X-MC-Unique: h5CVNPg7O1CRqIlytbL57Q-1
Received: by mail-pf1-f198.google.com with SMTP id 206-20020a6218d7000000b0051893ee2888so1521708pfy.16
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 17:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jVb+7zvjVPzPZa4Ju8Hh8oEGpXymYillvQMsMLxa+2o=;
        b=h8UbiTX2aAuslAfRN6nz5xnOkyQriXn2xh49AZhPwmLF/d1LsqVD0K5JjBc7MaDZNu
         ofUu9xRNL0SnVi2utDkpLmcPlEns2TnKUdHC/xlmlj4mix06VMpu6xwC57B2n3MEFxmx
         7s1roTtLaF+uABfJjCoVoMyk8zR56lTt0sNcCI3C3nvtMHe3F1FAPpySJ9ekXgoT4LMj
         FKgp6OKMfjjaQYHw/6rMIMYHERIQFTm/qkpyJ3AYpQTRbdcrXXbVhCE+ECTr4Iy7zZbe
         IdQYBNDCpUuD+HFYiY4D3sZbcxaGwtH2htjXzi5GrvpQKBpLyrzhxvUept0OuUQkF5QS
         LtFQ==
X-Gm-Message-State: AOAM530g5uRLzdjk7GjilXVBTD3zwviUItZvAw04CS/YxM6qoGsVLbO0
        XuvUxC5/rhEyREMdvzGDbybEvlWfimSkebR8FaJKRI0vSIMTuyPWfvy7gx1z0zJA9XK3XOkviiA
        dx/no4iIReBG0QT/wBEc3EQ==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr22720757pgw.599.1655081325166;
        Sun, 12 Jun 2022 17:48:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEjJK7rADZOyMguFMoIGmvKmBa4cM8uVdiGivkU9R3wGeaHaEipVwlHn+E3LTQdA8ghCGiPQ==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr22720748pgw.599.1655081324895;
        Sun, 12 Jun 2022 17:48:44 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902edc300b0015e8d4eb27esm3625864plk.200.2022.06.12.17.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 17:48:44 -0700 (PDT)
Subject: Re: [PATCH] ceph: switch back to testing for NULL folio->private in
 ceph_dirty_folio
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <20220610154013.68259-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6189bdb3-6bfa-b85a-8df5-0fe94d7a962a@redhat.com>
Date:   Mon, 13 Jun 2022 08:48:40 +0800
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

I have fixed the compile warning reported by kernel test robot by 
defining it in case the DEBUG_VM is disabled in testing branch.

-- Xiubo


>   #define VM_WARN_ON_ONCE_FOLIO(cond, folio)	({			\
>   	static bool __section(".data.once") __warned;			\
>   	int __ret_warn_once = !!(cond);					\

