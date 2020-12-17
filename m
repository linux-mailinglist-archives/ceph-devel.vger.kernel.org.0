Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430682DD610
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Dec 2020 18:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgLQR0L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Dec 2020 12:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgLQR0L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Dec 2020 12:26:11 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22B5C061794
        for <ceph-devel@vger.kernel.org>; Thu, 17 Dec 2020 09:25:30 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p187so28264054iod.4
        for <ceph-devel@vger.kernel.org>; Thu, 17 Dec 2020 09:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTY21EIftP79PpMvIqKIfZmDT+KN4RAnVuZavwRZrVM=;
        b=ITwhsh3G0ZfV+blwTnI8+k6IOAVh+SnAJBnKdBDXp18g+mGl8H4K+IRVajeVmgNj6P
         LmgGBQxvTJ/PsLcsNMWisEjll7/cLbhxAxSsvCtU3BpirMhJg90/SwExWguMQNVK2eV/
         jc7atZ+NIWcG5rpdpozF3RtkY8IuLRZHEQ9Aw5qCOuCQO4dh1OPuFdwMu0NHm103hsKZ
         bsXy7Fw28gjeBMpOgz1o7RLFh8n7BDu5TEdIhkoHmwf3+AXvcpRPk3ymD+9QiWrMeF8Y
         tAQdO5wvVUl0v+Ay2jaQHlYN2my3Ql6FoIj6s/TFQM5jEZZWW3mxzREuMaaPtd5QHjcx
         82XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTY21EIftP79PpMvIqKIfZmDT+KN4RAnVuZavwRZrVM=;
        b=AJgZvT0ERmtfd3fViAi5I+frT5Ebf0LK7nh0sx+YCmmrJgkfwrETX7dVnUVgIvxx5L
         NDASctpk2vOhynYu4sgwrJ3gjdDTOLX3v62VL71BE4p81DAhJnGrnWShA7EcW6o46mgZ
         NNhAVhFNYxx0byoDgOJqUpW0DH+Kdboey4x1Oq5a0IO1G4vTf9Of6J7lOvWiQiCwzQUU
         wchsH8YgT56Pc0HP89Y8VKzkvU/9ifKTmzEQF8udHfHNFjQZExyroXyyGIO52f03k5Qt
         vmS3VkSiWpe5n+bHMXtI2iKttA6j9E8hsxJAqI0ZJO61P3+uNnnU0vD8MRIhzf40YX9N
         pEhw==
X-Gm-Message-State: AOAM533PGQtxdjSfsdRGtnrQSODAblnahnJri339olP7pRKqOwsGBcJg
        fhln6bZ/b6lTqu7IzpXtAhbwb63l5mcfRseLJFBrcToZxPM=
X-Google-Smtp-Source: ABdhPJygWcOLjFMCohd4cJ1mMzN2LxtX1F2w04iGOwgwcOYwgW/xXyczJSjUde3nmD1ahDxLk78YQLauKoT39tQfrB4=
X-Received: by 2002:a02:bb99:: with SMTP id g25mr48698262jan.11.1608225930155;
 Thu, 17 Dec 2020 09:25:30 -0800 (PST)
MIME-Version: 1.0
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
 <87wnxk1iwy.fsf@suse.de> <CAOi1vP-U4Hdw=zYNFmhX_TJeuUiAAXMwvAUJLmG++F8mN+z5HQ@mail.gmail.com>
 <87sg881epx.fsf@suse.de> <877dpjyzw2.fsf@suse.de> <CAOi1vP8Qx8qLd0BtS_t8nn1ukXh0uAxveJOd=NyHv+rYnzTpBg@mail.gmail.com>
 <87sg848jow.fsf@suse.de>
In-Reply-To: <87sg848jow.fsf@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 17 Dec 2020 18:25:17 +0100
Message-ID: <CAOi1vP8D2em7QeZNn5h21UN8AF159ZqbwGxorP7sG2msQMJwYw@mail.gmail.com>
Subject: Re: wip-msgr2
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 17, 2020 at 5:45 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> Ilya Dryomov <idryomov@gmail.com> writes:
> <snip>
> >
> > Ah, I disabled KASAN for some performance testing and didn't turn
> > it back on.  This doesn't actually corrupt any memory because the
> > 96-byte object that gets allocated is big enough.  In fact, the
> > relevant code used to request 96 bytes independent of the connection
> > mode until I changed it to follow the on-wire format more strictly.
> >
> > This frame is 68 bytes in plane mode and 96 bytes in secure mode
> > but we are requesting 68 bytes in both modes.  The following should
> > fix it:
> >
> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > index 5e38c847317b..11fd47b36fc8 100644
> > --- a/net/ceph/messenger_v2.c
> > +++ b/net/ceph/messenger_v2.c
> > @@ -1333,7 +1333,8 @@ static int prepare_auth_signature(struct
> > ceph_connection *con)
> >         void *buf;
> >         int ret;
> >
> > -       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE, false));
> > +       buf = alloc_conn_buf(con, head_onwire_len(SHA256_DIGEST_SIZE,
> > +                                                 con_secure(con)));
> >         if (!buf)
> >                 return -ENOMEM;
>
> Looks like this fix didn't made it into your pull-request.  Did it just
> fell through the cracks, or is this fixed somewhere else on the code?

No, it didn't, it's in the testing branch:

  https://github.com/ceph/ceph-client/commit/add7ad675cd1bdaf2751da1af9295fb43896da66

Thanks,

                Ilya
