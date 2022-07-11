Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9573056D3B5
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Jul 2022 06:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiGKETq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Jul 2022 00:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGKETp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Jul 2022 00:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A309717A8D
        for <ceph-devel@vger.kernel.org>; Sun, 10 Jul 2022 21:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657513183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYSp6HlI0dDBIV/HDsecc6eKbJCd3YWkca9HdFglgEg=;
        b=LZM117yxang7gt+VslSpKs3tOfpvseM5MwRBI+HwZ7qPzH2Gd2NeOvQ1yTK9wBXIvghiW7
        zMDAYsxgbD4uDHSFoyuQVw7Aag9SFVlOEF+4lSda1ekj2Rrb9dKtgoNMmJ5tOTF0sPKZf+
        T4GXoYjBVZufAJzq196Yp4LqPR0K7fk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-OnnuOewFPs62z_11fLN_ow-1; Mon, 11 Jul 2022 00:19:39 -0400
X-MC-Unique: OnnuOewFPs62z_11fLN_ow-1
Received: by mail-pj1-f71.google.com with SMTP id l15-20020a17090a660f00b001ef7b1d2289so2858955pjj.9
        for <ceph-devel@vger.kernel.org>; Sun, 10 Jul 2022 21:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iYSp6HlI0dDBIV/HDsecc6eKbJCd3YWkca9HdFglgEg=;
        b=T1jtYRbGUn4Xu51Yv6D3MxfHOfxPpNrC6ck+wBk9gwLMwl8TtodO4Run+UEqZgo4J7
         NJy5OuNAwMWkQM6PpbpOs9CtMWj1iEu8GqGe4hHHTNhpEoqGnVZrpAOlJ92Iz/PA0/uK
         zVO8x4dZ/1TkungcUHOJImCVZ6DSEmIxRXZXXiml4kFZbsaKZ0B20YW8A61r1plNQKFy
         IvWqAH43vSN/FhKJxDvCKWc2RkWy0i08N5hLnicLIN56CVKO2evIdIrz8aO21yH27fOk
         ykAUPZEmlUt4BmJGdOkDv2yxnVvX4BzgNzlpBs2giHU9eC7MUTHNKR/OBvBb/Gl7LGTF
         BoJA==
X-Gm-Message-State: AJIora+hhh64huC7tCi7XGQhwGcJhGzw88GtcaDCX97OgmoSayLCuuHd
        iCI85kQFmTS/9P0c0vYLYxmjBHhK5LVfngEkoSpm5qwYlINFnoLW8iSgdrgfo15XhsKhgNfwvt0
        ffmcKVSU+UYzE9YQwYoSong==
X-Received: by 2002:a63:2c47:0:b0:411:54ab:97b6 with SMTP id s68-20020a632c47000000b0041154ab97b6mr14206431pgs.173.1657513178582;
        Sun, 10 Jul 2022 21:19:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sdLoGKlY/5zCNt7vw/gv0lyzTZM8Mh6bsyCtyMbXMA0uNpORIFIeDfE5UALrqX7MSFep4+Rw==
X-Received: by 2002:a63:2c47:0:b0:411:54ab:97b6 with SMTP id s68-20020a632c47000000b0041154ab97b6mr14206416pgs.173.1657513178370;
        Sun, 10 Jul 2022 21:19:38 -0700 (PDT)
Received: from [10.72.14.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902f54700b0016be4d310b2sm3543056plf.80.2022.07.10.21.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 21:19:37 -0700 (PDT)
Subject: Re: [PATCH v4] netfs: do not unlock and put the folio twice
To:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, marc.dionne@auristor.com,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        william.kucharski@oracle.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, vshankar@redhat.com
References: <20220707045112.10177-1-xiubli@redhat.com>
 <2520851.1657200105@warthog.procyon.org.uk>
 <YsbfCcNvjMVcT2yx@casper.infradead.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cf169f43-8ee7-8697-25da-0204d1b4343e@redhat.com>
Date:   Mon, 11 Jul 2022 12:19:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YsbfCcNvjMVcT2yx@casper.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/7/22 9:26 PM, Matthew Wilcox wrote:
> On Thu, Jul 07, 2022 at 02:21:45PM +0100, David Howells wrote:
>> -					 struct folio *folio, void **_fsdata);
>> +					 struct folio **_folio, void **_fsdata);
> The usual convention is that _foo means "Don't touch".  This should
> probably be named "foliop" (ie pointer to a thing that would normally
> be called folio).
>
This looks good to me.

I will send out the V5 by fixing this and will merge this patch via the 
ceph tree as discussed with David in the IRC and will cc the stable at 
the same time.

Thanks!

-- Xiubo



