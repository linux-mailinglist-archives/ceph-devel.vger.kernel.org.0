Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707BE50DBFC
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 11:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiDYJJf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 05:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbiDYJHf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 05:07:35 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C0C286D6
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 02:02:24 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id z144so4143616vsz.13
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 02:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MoBjZXt1gDwsKHLt8rwRC+MXIOViuJbvqaaVHvsFdu4=;
        b=FWv0Ujc1R4dY+p4cBEORM+1PvgK8HGyrCLknkBhsxzDVZUDv2ORamKY5h2HmqMBwkA
         sUKa0+JA4I3VtGq7dfP2/3nLJjkC0gO9zGbPEgNOoksYwWbSatHuvteKfQFesLkKAbs5
         mdfTLvtvbh9B2BH8kSpLh1Mxb+8ePz8WcQBtSBYtY8GyNGG5V99AYONwQGLkesvMbmO+
         jBV8Db56EhU4J03cYHbNflC3upuQZ0lIKJokHDSos6Cy0alu3lA/9lLSeYRPWgQD3oxV
         xw8/4whbjx+Pr7iG9YwY8ZMpCDxi2alY9RzuCCiNWsEU+FWhWGoz1Njk8f5HpjB5ml30
         eUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MoBjZXt1gDwsKHLt8rwRC+MXIOViuJbvqaaVHvsFdu4=;
        b=7V+rk+AHhdL9HW6aylpCEqReBSgbUq0M8iKY70Sp9s7hOh9TYohkHsc+2H9rzrpimT
         rGSg8oWXXdvVKnW6SyCg953LD3Rl1c+mveKWdhkYXWraMgkUWw2uDrabDn23BgASs2SI
         eTglncTn5G6Thx/98PePyGRyBsl5dp9OeYHuwuYiWf5I9CyKZQtVzwLX2XzQhk7RuypS
         WMonOhYWxz4Q9Qx4J7aQ8iMK0ixftUrOO8M7/+2rxrvautclCz8GPxN0FQ9cYYaLNjQK
         a3g6ssdNvhtdcSot74MeAyyYxSSrBI7NbLz1L/1nZ6+7l+p7sooB5ulOqN5YoNqwa8YM
         f+Zw==
X-Gm-Message-State: AOAM530xBjMnKKuzkqcDBSOXg4/h2DPg73mqB4yFpAGk895wi4bSXU04
        dN8jX/yVzquW4iWG/1chIEhnFOQa4wk7YL7XZ7I=
X-Google-Smtp-Source: ABdhPJwPzJCSPbSakkWn9xdTAs5CwCxmJLKvm9y96+xyfy6maSu6PyijdWk9nrEUqRrGTLPnFlEtwnjDmpJ2/oh+s3E=
X-Received: by 2002:a67:f499:0:b0:32a:5e86:eb62 with SMTP id
 o25-20020a67f499000000b0032a5e86eb62mr4552165vsn.45.1650877340537; Mon, 25
 Apr 2022 02:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220418014440.573533-1-xiubli@redhat.com> <20220418104318.4fb3jpdgnhje4b5d@ava.usersys.com>
 <53d24ea4-554b-2df3-e4ee-6761f6ae5c8e@redhat.com> <20220418144554.i7m6omhtulb2nq22@ava.usersys.com>
 <7a636228-263a-248c-cb41-a1872acd28f1@redhat.com>
In-Reply-To: <7a636228-263a-248c-cb41-a1872acd28f1@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 25 Apr 2022 11:03:08 +0200
Message-ID: <CAOi1vP-0jYr61B2BNcus8NwUOUByfr6t=FJF99wVEXe-H=+hCg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for req->r_session
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 19, 2022 at 3:01 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 4/18/22 10:45 PM, Aaron Tomlin wrote:
> > On Mon 2022-04-18 18:52 +0800, Xiubo Li wrote:
> >> Hi Aaron,
> > Hi Xiubo,
> >
> >> Thanks very much for you testing.
> > No problem!
> >
> >> BTW, did you test this by using Livepatch or something else ?
> > I mostly followed your suggestion here [1] by modifying/or patching the
> > kernel to increase the race window so that unsafe_request_wait() may more
> > reliably see a newly registered request with an unprepared session pointer
> > i.e. 'req->r_session == NULL'.
> >
> > Indeed, with this patch we simply skip such a request while traversing the
> > Ceph inode's unsafe directory list in the context of unsafe_request_wait().
>
> Okay, cool.
>
> Thanks again for your help Aaron :-)
>
> -- Xiubo
>
>
> > [1]: https://tracker.ceph.com/issues/55329
> >
> > Kind regards,
> >
>

I went ahead and marked this for stable (it's already queued for -rc5).

Thanks,

                Ilya
