Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88B4567B32
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Jul 2022 02:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiGFA6y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Jul 2022 20:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiGFA6x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 5 Jul 2022 20:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A05FCE0D
        for <ceph-devel@vger.kernel.org>; Tue,  5 Jul 2022 17:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657069131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/VIshmF4xT9wjWGvPNSfMhdl0xNY9tpFrPyWnO0aT8=;
        b=A/s6DgczCzsc6wIKrvToMEeh/tuL+RfN37gUORUNUs3O/I1RqVxvk2mvt4+mY3J3A8Y3OU
        folBGFVoj40+jhz3d12puk7jJ6ZjQq4Phj07h86lnYKViCIeMEr9HBxbeo1NF8gsuh/OqY
        1JnFTuuGfYRwXsMQMy8wCNrlL/QNCLQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-cYGqmgFFNde_xj7JBOkL8A-1; Tue, 05 Jul 2022 20:58:50 -0400
X-MC-Unique: cYGqmgFFNde_xj7JBOkL8A-1
Received: by mail-pg1-f197.google.com with SMTP id l189-20020a6388c6000000b0040d40295743so5313638pgd.15
        for <ceph-devel@vger.kernel.org>; Tue, 05 Jul 2022 17:58:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=L/VIshmF4xT9wjWGvPNSfMhdl0xNY9tpFrPyWnO0aT8=;
        b=Rdbg4UuzY7Zk7xFIvXXiWtMBUlUWWmVKDC6HpfMeZrEriwJKUbQgBv4xhLSX+XFrKb
         tgZZqioeYKnQ/cyBn5w1l6+HzqpDCFyyNKvE4gWcJwHAvaEOeibVDfM9VMiSsL4+GcnJ
         mL4cp1PILH/zPpvMAP2qk8jqzfZDIP0BIRyBVAZcFKGWBBZg2PhrGHyUxSa6XKhf+eWL
         Jse804t21HvhHx3F9m2ZxiDhh+4Gn4y/eNcVwD4P/vyR/7xFoedteK/C58LMhL2QtHiE
         IrmKnaJuBUZvmlQrcxAmYOu8tbrFJAjan25Az7XtZM4I7VL0HUPJ+8Kw85K7lLCTi9iy
         yNkA==
X-Gm-Message-State: AJIora/hRWQ9i2SAVHii8FwRd76y758l/c8UdiOZASTQjOhR2LLLdxR2
        wEM/afy3672n4Jazo5SLKRxFT0FtN5GNwb8/oq1HHuzig2kLBGFKY8JmjxV0gFw+yNSkXxI4/oh
        J37QoKobtuo1V/MQWFQ+brg==
X-Received: by 2002:a17:90a:e7c6:b0:1ef:9ab6:406e with SMTP id kb6-20020a17090ae7c600b001ef9ab6406emr7426865pjb.108.1657069128694;
        Tue, 05 Jul 2022 17:58:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1silTss9+EIoox09QHdHlVkmVoGOPWNKlZe23v0wKMWdZReT8feVbKNmYUOn6gMvpy4A5MnbA==
X-Received: by 2002:a17:90a:e7c6:b0:1ef:9ab6:406e with SMTP id kb6-20020a17090ae7c600b001ef9ab6406emr7426844pjb.108.1657069128474;
        Tue, 05 Jul 2022 17:58:48 -0700 (PDT)
Received: from [10.72.12.227] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b0016bec529f77sm3774563plh.272.2022.07.05.17.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 17:58:47 -0700 (PDT)
Subject: Re: [PATCH 1/2] netfs: release the folio lock and put the folio
 before retrying
To:     David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        willy@infradead.org, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com
References: <30a4bd0e19626f5fb30f19f0ae70fba2debb361a.camel@kernel.org>
 <20220701022947.10716-1-xiubli@redhat.com>
 <20220701022947.10716-2-xiubli@redhat.com>
 <2187946.1657027284@warthog.procyon.org.uk>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8ce8c30f-8a33-87e7-1bdc-b73d5b933c85@redhat.com>
Date:   Wed, 6 Jul 2022 08:58:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2187946.1657027284@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/5/22 9:21 PM, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
>
>> I don't know here... I think it might be better to just expect that when
>> this function returns an error that the folio has already been unlocked.
>> Doing it this way will mean that you will lock and unlock the folio a
>> second time for no reason.
> I seem to remember there was some reason you wanted the folio unlocking and
> putting.  I guess you need to drop the ref to flush it.
>
> Would it make sense for ->check_write_begin() to be passed a "struct folio
> **folio" rather than "struct folio *folio" and then the filesystem can clear
> *folio if it disposes of the page?

Yeah, this also sounds good to me.

-- Xiubo


> David
>

