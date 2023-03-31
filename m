Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5776D2120
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Mar 2023 15:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjCaNGK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Mar 2023 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjCaNGJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 Mar 2023 09:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181E5AF18
        for <ceph-devel@vger.kernel.org>; Fri, 31 Mar 2023 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680267920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgW8cTlK+PJOT8RKw+ZUtnYCCPaowJ5bRdHT0sOdQqU=;
        b=GKAcC+rzVs1W5lZ8eR44P9KPI686kEUBsrNi4GXoHT7Aopd+thSYit76fQCkFJdRjpPR6W
        wwkOldCmk1kz2zfJF25QFsJSPyvSrs8kWlrbJh1609u9ATxQ+hjKEM0W+czda0PGsfkwxa
        al89+n5fFwfOKpPkLkY1CbYTQ9u7OJk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-8d9GxHVuNhW5u_AoRoARmA-1; Fri, 31 Mar 2023 09:05:18 -0400
X-MC-Unique: 8d9GxHVuNhW5u_AoRoARmA-1
Received: by mail-pl1-f198.google.com with SMTP id a9-20020a170902b58900b0019e2eafafddso12860287pls.7
        for <ceph-devel@vger.kernel.org>; Fri, 31 Mar 2023 06:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267918;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hgW8cTlK+PJOT8RKw+ZUtnYCCPaowJ5bRdHT0sOdQqU=;
        b=1vx7feWiBQ7kyIIqTPBaVGbSvrO+ZcE0LAo8t/jsQlSRSV7ssJVZoPisL3B+6BTB6F
         hsMDW1H9EqzY/gCYhWxTNTGz9V3VaPFtA7RAQWUjx83S6GZx+QrmGD1YH3P4WxwG2YwP
         rB2cZdpEfim8eXwUm9sgUfGRR2nj1jn7c2d+vyVZg4CVpjk+z0LJD9mo3PSVs7QFfBPJ
         zDwyhNmx0W/uxi1TvIteqJsIC3R7+ap70kIWLUQf4IhbU5r0eZ8P0OGb8TuGJx1136tf
         xEV1VR9VL7tgxj0NRzjPQL2WS9kcMVkdG8u/Yj713aNcLOEs2L261uaRX1rd6Zt+Eh+z
         KY4w==
X-Gm-Message-State: AAQBX9fIMUgyk2EIUZ2bvHNk48kUQ09bSUbvLHObsuzSK4/F/lfVk510
        A8KB3LtCcAdnE9Hmz+BMoX+juTonP5Y31fvBvKlkucz10n26zRp2pBxwnYurRwvSADwHyoVsATF
        jsRdNUHGbtsiEXV6CpDPOew==
X-Received: by 2002:a17:90b:4a50:b0:240:59e8:6dad with SMTP id lb16-20020a17090b4a5000b0024059e86dadmr25379903pjb.25.1680267917837;
        Fri, 31 Mar 2023 06:05:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y9PfdWxol+rufcZcwbvwQ1DYEPsLuXLElCIM70TdWdw8rbW3NRn8loQ1UIz8coXa9Ci2UCbA==
X-Received: by 2002:a17:90b:4a50:b0:240:59e8:6dad with SMTP id lb16-20020a17090b4a5000b0024059e86dadmr25379876pjb.25.1680267917496;
        Fri, 31 Mar 2023 06:05:17 -0700 (PDT)
Received: from [10.72.12.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090ac24400b002407750c3c3sm1409435pjx.37.2023.03.31.06.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 06:05:17 -0700 (PDT)
Message-ID: <94f0894d-f72c-daa3-10e2-e83e0e15a759@redhat.com>
Date:   Fri, 31 Mar 2023 09:05:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH v2 37/48] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather
 than sendpage()
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
References: <7f7947d6-2a03-688b-dc5e-3887553f0106@redhat.com>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-38-dhowells@redhat.com>
 <709552.1680158901@warthog.procyon.org.uk>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <709552.1680158901@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/30/23 02:48, David Howells wrote:
> Xiubo Li <xiubli@redhat.com> wrote:
>
>> BTW, will this two patch depend on the others in this patch series ?
> Yes.  You'll need patches that affect TCP at least so that TCP supports
> MSG_SPLICE_PAGES, so 04-08 and perhaps 09.  It's also on top of the patches
> that remove ITER_PIPE on my iov-extract branch, but I don't think that should
> affect you.

Okay, I will check that.

Thanks.


> David
>

