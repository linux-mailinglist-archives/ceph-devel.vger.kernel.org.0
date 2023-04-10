Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FAD6DC22E
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Apr 2023 02:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjDJAjd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Apr 2023 20:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJAjb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Apr 2023 20:39:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD7A30E6
        for <ceph-devel@vger.kernel.org>; Sun,  9 Apr 2023 17:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681087124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JoipxyuFINXgUm44ia8nIP1Z7voF8xXNR8jbsieNzXY=;
        b=YqUxcugPP/3M5a71ljI07cZ6CVsLxITnj4+wu+mzA/D82YGUFGRl/gAX7vYNkGoF1et5Up
        SUEFqAb+sjCiEO8EsyMU3HSVghyJUSg5UrgwoxVnmIegokeW89wkZgFhSsFFV/fV4k0olz
        bRx6lajxqJ7+6Nu2qhNrhx7uVwOx5WU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-BIABkvJNMr6vHZGTpeP1aw-1; Sun, 09 Apr 2023 20:38:41 -0400
X-MC-Unique: BIABkvJNMr6vHZGTpeP1aw-1
Received: by mail-pl1-f198.google.com with SMTP id u10-20020a170902e80a00b001a043e84bdfso2552488plg.23
        for <ceph-devel@vger.kernel.org>; Sun, 09 Apr 2023 17:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681087121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JoipxyuFINXgUm44ia8nIP1Z7voF8xXNR8jbsieNzXY=;
        b=baNmWaAvBLXXRqd+vmvPnERilKIdX9TVFpYwqjGGKmF5Tr1zwwhe5fp41dxec0kCDH
         BDkJj4qp2vGSuY2PI4q/TgaWX/ZzRVcZaQ75HYikpjUSZ7V8bQSVegA66ChxmTy4vQKU
         mTrZlF3lzM+tWzZ/2OmtvT5bqLOkdy3/rborsmvxGtxkQPscOloB22ugq1qgPFIp+7dn
         gOweh1ABGc2cMbmCDxAOll456ug8tRE2INgUpYjM2arOvK1ffjL577JlxcG2WHC6pbjc
         dLpiWpWb+UTNx486WSt6iQWNcuh55EQCWtKPQNhWfxpK4PSg8cl/+zCxwEVsJrh0M362
         EvcA==
X-Gm-Message-State: AAQBX9dFrAuAAeyydWOq83O3vI3pOTMDjuWpvWgcqc+ihXoPoz7gtl8x
        yuibgN++DfFzp2X4GklLe/2h5P1uwS1ohJ+0kyG/1U4Ixu0eFUVjGnxCOTXQdoLwIwFpvDsm9Xw
        6xPe3/sOmArZSFlxGz3nBLQ==
X-Received: by 2002:a17:903:2309:b0:1a0:4fb2:6623 with SMTP id d9-20020a170903230900b001a04fb26623mr13634386plh.40.1681087120701;
        Sun, 09 Apr 2023 17:38:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350bBhI9mfvIxmgS3HdFTr0TeJ85lYetpQhXwNJ7ayezRXC3PbhU01R+aemZYHD/yCMAoEoKv5w==
X-Received: by 2002:a17:903:2309:b0:1a0:4fb2:6623 with SMTP id d9-20020a170903230900b001a04fb26623mr13634356plh.40.1681087120361;
        Sun, 09 Apr 2023 17:38:40 -0700 (PDT)
Received: from [10.72.12.179] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902988400b0019cd1ee1523sm6420247plp.30.2023.04.09.17.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Apr 2023 17:38:39 -0700 (PDT)
Message-ID: <5019ac6e-6871-9439-b24f-6bcb24bd89d8@redhat.com>
Date:   Mon, 10 Apr 2023 08:38:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH v2 37/48] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather
 than sendpage()
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <c99f1f3d-25ac-6f5c-b5f1-26f7bfa513e8@redhat.com>
 <7f7947d6-2a03-688b-dc5e-3887553f0106@redhat.com>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-38-dhowells@redhat.com>
 <709552.1680158901@warthog.procyon.org.uk>
 <1814785.1680510766@warthog.procyon.org.uk>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <1814785.1680510766@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/3/23 16:32, David Howells wrote:
> Xiubo Li <xiubli@redhat.com> wrote:
>
>> On 3/30/23 14:48, David Howells wrote:
>>> Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>>> BTW, will this two patch depend on the others in this patch series ?
>>> Yes.  You'll need patches that affect TCP at least so that TCP supports
>>> MSG_SPLICE_PAGES, so 04-08 and perhaps 09.  It's also on top of the
>>> patches that remove ITER_PIPE on my iov-extract branch, but I don't think
>>> that should affect you.
>> Why I asked this is because I only could see these two ceph relevant patches
>> currently.
> Depends on how you defined 'relevant', I guess.  Only two patches modify ceph
> directly, but there's a dependency: to make those work, TCP needs altering
> also.

Okay. Will run the test today. I was reinstalling my laptop last week.

Thanks

- Xiubo

> David
>

