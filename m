Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BD973FC49
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 14:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjF0M4d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 08:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjF0M4c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 08:56:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652232943
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687870528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jRl7aKap1SeKgVZS63rqtI75g0CI3hogPpCfcoBBCMs=;
        b=TFpHYt68XTuVGjp11sKwtwsaxUPxzrJhwiBDHxfwH7I3RzQP6DMvdB+Mo6uFWPJApOJIRP
        00zlU+/6oCk4+UlMxXTvj+bluowCBLaYA6fKAmsSKeLPOSPj2RktXibjW2rBfX8/C3o9mb
        F734yiiHF2vsgo48BK1W/2mOdSz/BFQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-Q83joPRlPAeCynucpw5Gtg-1; Tue, 27 Jun 2023 08:55:24 -0400
X-MC-Unique: Q83joPRlPAeCynucpw5Gtg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76716078e78so3605385a.1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687870524; x=1690462524;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jRl7aKap1SeKgVZS63rqtI75g0CI3hogPpCfcoBBCMs=;
        b=KLeFZqTJWMuATBiMYQWSCjVW4pw6VuF+2/VXNO9pNF9Ltv4mYRr/bMZxDIfH2U/+Ne
         KR3hdozT9CTCa9ePRAyLxZ5YDOLyYWeSWgzd+jfoZwDIW7jicwtnS2NNWjsssheZUNZ+
         a791x0H6dopolX9uF4CfSEfiROfpKtgv2nx7c55HGyLOQAx8bKjFAAtFhOnP4sGbyYS9
         LOLvaYJuR0b8hEKXNL2wU/sK1zrbSQKYCfX8ARi3/KmJ7BIXOlStnOSgW+MtD4cB4QWv
         XiOMCzZU68/WRZO8pE7AOWqq6IcXvFo/td51eNaGnRxXkbGIpvNAT+NR0QwfDrzwvx7r
         IkqQ==
X-Gm-Message-State: AC+VfDxJctPoGILg7Mvxn2tVd09aWwLIZr9zXXy8XvJwzfdSFxJpbprL
        BSW86XMKcyAE7d8a+yrWCaRDC9HiWnFMqBY8D6YIUuvtSkU6m06rwtBtqvn0y1DWudqASiGRHh3
        YbTeYOR80jfrTBkF3io68pg==
X-Received: by 2002:a05:620a:190e:b0:765:3b58:99ab with SMTP id bj14-20020a05620a190e00b007653b5899abmr2670208qkb.4.1687870523898;
        Tue, 27 Jun 2023 05:55:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5MVSVOTOJGm6y6OkidtOFcnyLv70o/VU/KFN2yDxpJyfTZKFyUUry0ejHmhywBuZIZSQ+qRw==
X-Received: by 2002:a05:620a:190e:b0:765:3b58:99ab with SMTP id bj14-20020a05620a190e00b007653b5899abmr2670184qkb.4.1687870523654;
        Tue, 27 Jun 2023 05:55:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-6.dyn.eolo.it. [146.241.239.6])
        by smtp.gmail.com with ESMTPSA id j7-20020a05620a146700b00765516bd9f2sm3912923qkl.33.2023.06.27.05.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 05:54:07 -0700 (PDT)
Message-ID: <1f4271105ac5be66e5130d487464680fc65bacc8.camel@redhat.com>
Subject: Re: Is ->sendmsg() allowed to change the msghdr struct it is given?
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 27 Jun 2023 14:54:02 +0200
In-Reply-To: <b0a0cb0fac4ebdc23f01d183a9de10731dc90093.camel@redhat.com>
References: <3112097.1687814081@warthog.procyon.org.uk>
         <20230626142257.6e14a801@kernel.org>
         <b0a0cb0fac4ebdc23f01d183a9de10731dc90093.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2023-06-27 at 14:51 +0200, Paolo Abeni wrote:
> On Mon, 2023-06-26 at 14:22 -0700, Jakub Kicinski wrote:
> > On Mon, 26 Jun 2023 22:14:41 +0100 David Howells wrote:
> > > Do you know if ->sendmsg() might alter the msghdr struct it is passed=
 as an
> > > argument? Certainly it can alter msg_iter, but can it also modify,
> > > say, msg_flags?
> >=20
> > I'm not aware of a precedent either way.
> > Eric or Paolo would know better than me, tho.
>=20
> udp_sendmsg() can set the MSG_TRUNC bit in msg->msg_flags, so I guess
> that kind of actions are sort of allowed.

Sorry, ENOCOFFEE here. It's actually udp_recvmsg() updating msg-
>msg_flags.

>  Still, AFAICS, the kernel
> based msghdr is not copied back to the user-space, so such change
> should be almost a no-op in practice.

This part should be correct.

> @David: which would be the end goal for such action?

Sorry for the noisy reply,

Paolo

