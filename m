Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8552D392A8
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 19:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfFGRAl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 13:00:41 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:34860 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfFGRAj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 Jun 2019 13:00:39 -0400
Received: by mail-io1-f45.google.com with SMTP id m24so1958788ioo.2
        for <ceph-devel@vger.kernel.org>; Fri, 07 Jun 2019 10:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3t1+EkYtzd4ceShN5yJXmRooepXBWprvxABwURCAe2o=;
        b=BFgAUp9xDj/A1P9G427VaSuU1uhC745ULQh8MrDzWHQqI2LIzFugOE598fZOBEaEBK
         xIT5fxbV7TpXiZLjeVL5+UwE6whvjkpFJyv3Op5xTg1ziiGjIJOGDPCiYLwvmvaV+Hmo
         NjBsBnuA8jN2FPRfNGmvV4TReP9GIELE6Mq5CVo1VUTWY402xWTEXGnrX9OXVvlavKcW
         JSDCiMIVd632Aqpm0PRIqbjUS94kPUJue3IYQxuA+KRkmcv5txkqybz9CS4Xe2zpD5Vn
         5g/agssQUmHsKSh7eOnwvMR1V1vN4fKECJSe2G7W2P3oXKEXl6B+pNVP5DUuF7kUHnHz
         iDRA==
X-Gm-Message-State: APjAAAXYkDn879goZE5I3ZVRGgseberVZ24GzR2DWyuf930CIQZgWfaG
        r9ZdbsoBMbJcxXfsQStgZu58Pje4zbDUeUkjTRaKOw==
X-Google-Smtp-Source: APXvYqyzzlnFLoKVDXFhHte+7ULieNx4Yb1YevhJhrv26qzbRMhoALg3XUQrSsCD7ljfeTjjYEKac8wDQzvcBN9K3hU=
X-Received: by 2002:a6b:6012:: with SMTP id r18mr11641250iog.241.1559926839138;
 Fri, 07 Jun 2019 10:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1905301812380.29593@piezo.novalocal>
 <alpine.DEB.2.11.1906051630420.13706@piezo.novalocal> <CAJACTufv89tC=BOGJLn=ufjdh9q25NFcETg-nfodk_Rxh=KLmg@mail.gmail.com>
In-Reply-To: <CAJACTufv89tC=BOGJLn=ufjdh9q25NFcETg-nfodk_Rxh=KLmg@mail.gmail.com>
From:   Mike Perez <miperez@redhat.com>
Date:   Fri, 7 Jun 2019 10:00:27 -0700
Message-ID: <CAFFUGJdCz8QLv7Xdm7nLRW9Jyea5iRRZZ9hYNaVf4ENnhLgRWA@mail.gmail.com>
Subject: Re: CDM next Wednesday: multi-site rbd and cephfs; rados progress events
To:     Xuehan Xu <xxhdx1985126@gmail.com>
Cc:     Sage Weil <sage@newdream.net>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Xuehan,

Here are the recordings for this meeting:

https://www.youtube.com/watch?v=EG-3rcvqvGI
https://www.youtube.com/watch?v=vYY4yngqMsQ

--
Mike Perez (thingee)

On Wed, Jun 5, 2019 at 7:24 PM Xuehan Xu <xxhdx1985126@gmail.com> wrote:
>
> > BTW for those using Chrome, for some reason using the redhat.bluejean.com
> > URL variant works better for me (doesn't prompt me to install the app):
> >
> > https://redhat.bluejeans.com/908675367
> >
> > sage
>
> Hi, everyone.
>
> Sorry, I missed the CDM last night, I was too tired and had to work at day time.
> Could anyone share the recording, please? Thanks:-)
