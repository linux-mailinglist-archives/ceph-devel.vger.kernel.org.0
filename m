Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1158C5E19A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfGCKGX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 06:06:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41840 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfGCKGX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 06:06:23 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so3377397ioc.8
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 03:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GwE4sMZYSHb15r/5z3QnHIFngFm8uAAaAJMq2rBV3Mo=;
        b=g7XlPfiIhLdTOaSmTDt99tb0mFUotLeasdFXXBrV2fTS0NM44TuDb1C4o5jsA1Ky1a
         dhXZmNkm0v9i2KEub9zcxfkZ06LkPd9d8H9LOF5rGJ7slJx1CilqcSD9sq/RKxOT9v/H
         hZcG6j1QOLIu7jAfllRjYM0CpEgZp3mxEcCGw27BoQoetxlHBOhYAJtZkFSlTHU5YmJ2
         6VjTihm1lTHSLw+OvLIW/+nMeyRExEDvibhaEFjpxDRoV8dZH4pfRJ/MsWoDpVaE+TYG
         P8S3fugY5cWYQMDSLMGXMT395hRsXB5HIxIvM9V11+xMUqt9T1ZaCbYffC0A3z3gpdx3
         cCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GwE4sMZYSHb15r/5z3QnHIFngFm8uAAaAJMq2rBV3Mo=;
        b=On50O2muZVsoyLSq3/hLdHhYUwt0Drct3m3tcy8T7PXF5Y02mj85Eb3qC7Mbgd6dcH
         lPKHULu7eq0UaD3JUEsklXbCbK4ag72VyJLPfKJHxSfycsU6eA6/TXh+bpy10vj6SEAl
         rBhn+gNyEtUf7s50Aqm65TnFLDNMCk0i6s/Mbi41lCrx3GVT9o5MGRcazgazSk9xS485
         5ZbpvOWoWLv9CGzvWC1r8GXNl7MN1TIsvQb/iyEYtcIeRMxcy/NYv5faLlVORJ1ui3Rm
         YAqD2DUcgI5nyBkyjOgw+pyyo9YcZg0SeADL3YIiN3UkiJhetn6mrA7xrycD+fSv3HZ3
         dChg==
X-Gm-Message-State: APjAAAWLwozdvzGZ5vIGs5u0nThzhBl3AwevUloKeVCZGGxDA+CADYpv
        PllyMVD0D530MenO+TVcODiYr3Q40/V/OJ8g4gJ94sis
X-Google-Smtp-Source: APXvYqycJa1y2EXNLPbsVxvpA11PXils15dWvTD2hBQybyzDTQrYpKQNDOoNk2gSoNANPA70+vxGHwaezIqJC9TL7mc=
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr11069643iog.131.1562148382732;
 Wed, 03 Jul 2019 03:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-16-idryomov@gmail.com>
 <9dc2dff0cf07b41cb9ba52e4846e4d783ac39b91.camel@kernel.org>
In-Reply-To: <9dc2dff0cf07b41cb9ba52e4846e4d783ac39b91.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 12:09:03 +0200
Message-ID: <CAOi1vP9+BMehn2hy0t0VL-uEK9PzMEB8J+4E5bD0w0t-SBGLbg@mail.gmail.com>
Subject: Re: [PATCH 15/20] libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 12:51 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2019-06-25 at 16:41 +0200, Ilya Dryomov wrote:
> > This time for rbd object map.  Object maps are limited in size to
> > 256000000 objects, two bits per object.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  include/linux/ceph/libceph.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index 337d5049ff93..0ae60b55e55a 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -84,11 +84,13 @@ struct ceph_options {
> >  #define CEPH_MSG_MAX_MIDDLE_LEN      (16*1024*1024)
> >
> >  /*
> > - * Handle the largest possible rbd object in one message.
> > + * The largest possible rbd data object is 32M.
> > + * The largest possible rbd object map object is 64M.
> > + *
> >   * There is no limit on the size of cephfs objects, but it has to obey
> >   * rsize and wsize mount options anyway.
> >   */
> > -#define CEPH_MSG_MAX_DATA_LEN        (32*1024*1024)
> > +#define CEPH_MSG_MAX_DATA_LEN        (64*1024*1024)
> >
> >  #define CEPH_AUTH_NAME_DEFAULT   "guest"
> >
>
> Does this value serve any real purpose? I know we use this to cap cephfs
> rsize/wsize values, but other than that, it's only used in
> read_partial_message:
>
>         data_len = le32_to_cpu(con->in_hdr.data_len);
>         if (data_len > CEPH_MSG_MAX_DATA_LEN)
>                 return -EIO;

data_len is used for allocating the buffer for non-preallocated
messages (osdmap, watch/notify, etc).

>
> I guess this is supposed to be some sort of sanity check, but it seems a
> bit arbitrary, and something that ought to be handled more naturally by
> other limits later in the code.

For preallocated messages, this check could probably be removed.  For
non-preallocated messages, the value could have been lower.  However,
it's been there forever, so I would probably tend to keep it.  It's nice
to have these limits at a glance...

Thanks,

                Ilya
