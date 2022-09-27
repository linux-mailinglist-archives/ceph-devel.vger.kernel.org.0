Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5933B5EC02F
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Sep 2022 12:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiI0Kz4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Sep 2022 06:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiI0Kzz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Sep 2022 06:55:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C463818E2F
        for <ceph-devel@vger.kernel.org>; Tue, 27 Sep 2022 03:55:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f20so12660694edf.6
        for <ceph-devel@vger.kernel.org>; Tue, 27 Sep 2022 03:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Uei1CC5te+qNPDdpiy4J9GEGK0BnlFEGKUkoi7L2F08=;
        b=cunI1SN+BdkXdJsHhPHf08gdFekcqNsg73A8q4IF7C4mmJRulg6U2uPp+ANI6xrJIl
         /vCDP3eHn6LDoAuEnv7M5ljnhXFFSjRqN2Z2+13/L+bwbJtgWkxIyVeHQEPuIA0pvqqe
         vPzUta2KlwX46t9YOgq43A7/vBNt0vjbOuKUhy6uCSfmj15oJLs6KyvIDpkwJxxnMNME
         jHWbEN4P6iVbdILoXlEhJzjrM5rOfcc5PAN0MGb9EObXubxAuiGOJPaMzQnitS8qHAnu
         9dr9NqFnZkPuMYju9A9i5Fj5X+f2gWs9pSzdCEBeztJCM83obs8kUngeSqwhDjMgm/kf
         YLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Uei1CC5te+qNPDdpiy4J9GEGK0BnlFEGKUkoi7L2F08=;
        b=2SqNWBbU+RJJmoHNdT2lxxGF4uGfMeIdhAEkJW60hPTNvcHrk3Md38WA+uzq5SvzwT
         rhXRNPxiRzw1lhv9TYtojxzpx6PYiV7z3QTQULNh3UKSIA6mhC3wlSIg4zledaiwe7ya
         KwAxQ3X6q1Ptz5mt2W+GBJtH7ppbC1GxoN3+k6/NALMePSB7wJ7aV7t9SMKnERO6pua0
         FiQbOLp9w/9J3/8pGv6x74mpBXKCGoKj8z5SHzz99qFXEbl6KDqTKX8lZFn98+e657Wz
         A1p/YdJGoeQ/+7BDmfXSvz4RhA5lvHdAbaB3Em9YGne62HDjFchWCoaWf7ey65UKCg+x
         lblA==
X-Gm-Message-State: ACrzQf0DU1yiJcM1k+7rDHrq5eugdnJsuPsqRKy5lnis7eHT4xyu6xAP
        xxE9viyGJnNIXBs5mwqHV4wzIcCKUaHNmLQWAWM=
X-Google-Smtp-Source: AMsMyM6y7oAYWC3cnZ4S3tReCicopRdEADfH1WYPU/eAqJaQFvStz92CqJbzQJhY5PDvlitwizcjiFUgqqnQarNXlCc=
X-Received: by 2002:a05:6402:51d1:b0:451:ea13:1583 with SMTP id
 r17-20020a05640251d100b00451ea131583mr27255014edd.322.1664276149099; Tue, 27
 Sep 2022 03:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au> <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au> <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au> <20220919074321.GA1363634@onthe.net.au>
 <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
 <20220921013629.GA1583272@onthe.net.au> <CAOi1vP__Mj9Qyb=WsUxo7ja5koTS+0eavsnWH=X+DTest4spaQ@mail.gmail.com>
 <20220923035826.GA1830185@onthe.net.au> <CANqTTH4dPibtJ_4ayDch5rKVG=ykGAJhWnCyWmG9vvm1zHEg1w@mail.gmail.com>
In-Reply-To: <CANqTTH4dPibtJ_4ayDch5rKVG=ykGAJhWnCyWmG9vvm1zHEg1w@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 27 Sep 2022 12:55:37 +0200
Message-ID: <CAOi1vP9jCHppG7irvLzQgwBSzhrfgc_ak1t2wc=uTOREHVBROA@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Guillaume Abrioux <gabrioux@redhat.com>
Cc:     Chris Dunlop <chris@onthe.net.au>, ceph-devel@vger.kernel.org
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

On Fri, Sep 23, 2022 at 3:06 PM Guillaume Abrioux <gabrioux@redhat.com> wrote:
>
> Hi Chris,
>
> On Fri, 23 Sept 2022 at 05:59, Chris Dunlop <chris@onthe.net.au> wrote:
>>
>>
>> If the ceph containers really do need access to the entire host
>> filesystem, perhaps it would be better to do a "slave" mount,
>
>
> Yes, I think a mount with 'slave' propagation should fix your issue.
> I plan to do some tests next week and work on a patch.

Hi Guillaume,

I wanted to share an observation that there seem to be two cases here:
actual containers (e.g. an OSD container) and "cephadm shell" which is
technically also a container but may be regarded by users as a shell
("window") with some binaries and configuration files injected into it.

For the former, a unidirectional propagation such that when something
is unmounted on the host it is also unmounted in the container is all
that is needed.  However, for the latter, a bidirectional propagation
such that when something is mounted in this shell it is also mounted on
the host (and therefore in all other windows) seems desirable.

What do you think about going with MS_SLAVE for the former and MS_SHARED
for the latter?

Thanks,

                Ilya
