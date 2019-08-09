Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AEA87803
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 12:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406439AbfHIK42 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 06:56:28 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37026 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406078AbfHIK40 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Aug 2019 06:56:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id s20so65436899otp.4
        for <ceph-devel@vger.kernel.org>; Fri, 09 Aug 2019 03:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAwFIeQ6DNAw8O5EBLa42Zqfsz5R7enOKT3KQy9UDiA=;
        b=arRencZMzeRXHnE+TK2C9sdLUoLupBaEA+kSxgEOasFzWwHBWYhS8902ltywdr1y60
         3j9HkD//AC/EvlE/DQJKzytv+rznWZAyAFV8PEzPccxvBHgfJ6N+i7L3bEV1hQu+o9y7
         h5tvBWO+O/mG6iuJ0S0SCx6q69xDzdRH5OyhusCdeiScgx/ehn6zJ7i5QzR/5EHuwVjo
         kAQlwD41H+L3I9eqh+Xs2Ey/McpQ/DQP98if+ngWV+KpAtmkyZBJft9RQUeDwH6Fy0xZ
         2YBSwwc9rj+vPOEtBIQCxznLAego4gXoHeMrY08oXxry7BM8ZGY4YaYcy9+P57k1zeYv
         WBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAwFIeQ6DNAw8O5EBLa42Zqfsz5R7enOKT3KQy9UDiA=;
        b=Szp9gdTbsQEOl69lb+HjIsb1ujrWIel5sB6dn8M3fXmRybr0DI5A/2ZY8/Ao+23Xbx
         0vrXqHmfUVyMjmYx/p4jnDFYOTDhmpdJ4JSOqdje08+Eti25Nl2DRVH+41XbwPN5yGnu
         BvaekG3ALBKSBFNB10m/0RJr1/YFps6E+An7nwrqcLBwK/Yq8IstXdkQGDqe/OpKPY34
         CycERo9HxgORpUcUebjfGo+9owNNTRZc2oJQ8wJtQwW7kGZLnMPRjhj93trh+Rj0xmr6
         v7iicy8B+Ee7wBUputEHc+/LLGpofmmgSBSlRXIuqoeOMpRzUemg6+X1BDV3lhxwxOig
         MZ1Q==
X-Gm-Message-State: APjAAAWZEXfks9riAeKXUqmg4R/5vxFDtk/EIRXW9ipzKjaHhTaU5fIl
        +JMbwkDcI4Bb/C8jSSkpiBpls2KMZwkAZzzqqeROkKLm
X-Google-Smtp-Source: APXvYqyWwF4FZfN9LdC4uBt3iHzwJMxmdY5JcPAXS4iOoSik8zIUgYvdQS9RHV/gwqsEqYwoygBTS7ZKUDY9AYKV4pQ=
X-Received: by 2002:a5d:924e:: with SMTP id e14mr19109600iol.215.1565348185874;
 Fri, 09 Aug 2019 03:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <1565334327-7454-1-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP9p8YHykG3dmUa=VekcTSd+3hOei4N+JDcMDSoqvV10aQ@mail.gmail.com> <5D4D2477.20204@easystack.cn>
In-Reply-To: <5D4D2477.20204@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 9 Aug 2019 12:59:22 +0200
Message-ID: <CAOi1vP_Ybwrpr7Qa259LbUidLCnXVUHr6YYrJODc3GWJwQm5sQ@mail.gmail.com>
Subject: Re: [PATCH] rbd: fix response length parameter for rbd_obj_method_sync()
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 9, 2019 at 9:45 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 08/09/2019 03:34 PM, Ilya Dryomov wrote:
> > On Fri, Aug 9, 2019 at 9:05 AM Dongsheng Yang
> > <dongsheng.yang@easystack.cn> wrote:
> >> Response will be an encoded string, which includes a length.
> >> So we need to allocate more buf of sizeof (__le32) in reply
> >> buffer, and pass the reply buffer size as a parameter in
> >> rbd_obj_method_sync function.
> >>
> >> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> >> ---
> >>   drivers/block/rbd.c | 9 ++++++---
> >>   1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> >> index 3327192..db55ece 100644
> >> --- a/drivers/block/rbd.c
> >> +++ b/drivers/block/rbd.c
> >> @@ -5661,14 +5661,17 @@ static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
> >>          void *reply_buf;
> >>          int ret;
> >>          void *p;
> >> +       size_t size;
> >>
> >> -       reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
> >> +       /* Response will be an encoded string, which includes a length */
> >> +       size = sizeof (__le32) + RBD_OBJ_PREFIX_LEN_MAX;
> >> +       reply_buf = kzalloc(size, GFP_KERNEL);
> >>          if (!reply_buf)
> >>                  return -ENOMEM;
> >>
> >>          ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
> >>                                    &rbd_dev->header_oloc, "get_object_prefix",
> >> -                                 NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
> >> +                                 NULL, 0, reply_buf, size);
> >>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
> >>          if (ret < 0)
> >>                  goto out;
> >> @@ -6697,7 +6700,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
> >>
> >>          ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
> >>                                    "get_id", NULL, 0,
> >> -                                 response, RBD_IMAGE_ID_LEN_MAX);
> >> +                                 response, size);
> >>          dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
> >>          if (ret == -ENOENT) {
> >>                  image_id = kstrdup("", GFP_KERNEL);
> > Hi Dongsheng,
> >
> > AFAIR RBD_OBJ_PREFIX_LEN_MAX and RBD_IMAGE_ID_LEN_MAX are arbitrary
> > constants with enough slack for length, etc.  We shouldn't ever see
> > object prefixes or image ids that are longer than 62 bytes.
>
> Hi Ilya,
>      Yes, this patch is not fixing a real problem, as you mentioned we
> dont have
> prefixes or image ids longer than 62 bytes. But this patch is going to
> make it
> logical consistent.
>
> The most confusing case is for rbd_dev_image_id(), size of response is
> already
> RBD_IMAGE_ID_LEN_MAX + sizeof (__le32). but the @resp_length in
> rbd_obj_method_sync()
> is still RBD_IMAGE_ID_LEN_MAX.

I see, consistency is a good thing.

I amended the changelog and applied with a minor whitespace fixup:

https://github.com/ceph/ceph-client/commit/1a25b186a7526185e74ee799a956f8bd32aa82fb

Thanks,

                Ilya
