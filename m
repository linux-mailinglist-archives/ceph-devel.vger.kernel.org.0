Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02AE436374
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Oct 2021 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJUNzT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 09:55:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhJUNzS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 09:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634824382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRKlQVP5q9wu9q0KFDh68sx4zgVOkV7V7+M/iuIu2a0=;
        b=PNEj/b99hF/hlm++NrLaK9bzT8UXUqGWkxAHZ9YteFzc30bIA0HCcq1LswUCKv2KXbv61b
        Ix8y1vwuAEeiIpMH0hv1yqjUZDEwrblcKaCQuiM8g0GIBKJwwiI/cwxF1NUlCjYwZA9WzZ
        H71E/c7JMRDA7hBDfZoaIrSuerTY/s8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-pTJ9TxFVPBGwCk_7LeEnLA-1; Thu, 21 Oct 2021 09:52:59 -0400
X-MC-Unique: pTJ9TxFVPBGwCk_7LeEnLA-1
Received: by mail-io1-f72.google.com with SMTP id y9-20020a5e8349000000b005ddb44e9eb8so456681iom.19
        for <ceph-devel@vger.kernel.org>; Thu, 21 Oct 2021 06:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uRKlQVP5q9wu9q0KFDh68sx4zgVOkV7V7+M/iuIu2a0=;
        b=HnGN9dq3ZOifiduFsLCZMAgulfn5cpSvow+3WctIgnqm2j3JekliGwBeP46mNqQ6jg
         Hta4vwycR7uQXcnTRjvDf/sF0DIJuW76y5EDyC365/jVmH4qklv9J3bfj4Pl81UYh6o8
         N4ke8HVGVGG1+Ekvw8z4eo3Q/vt98up9htBso01ko1hfb92HNwI1btjJWIccoHaIJiBC
         gfM3BuDbg61NVZF0DnJsMYcdx8yZXk9LgPJaCGO3kknTbklLdPGW7X3YOELtTzZgwJRl
         CChHeNpf0HKbcWwINK5E6ZlDUGuhmW/xdS9V+OUbhGg0BE/zyG5YTGHgylgqdX38NHuO
         yjOA==
X-Gm-Message-State: AOAM5330Kj7gftoOE6VNUNDpeMQx5vyxz7h7L59LtzpcgyyyIP5+SsB0
        TL+R/pLv3qAF2dOhRyAK/3812vN49gdtLxXsw3a8QPJaXAkfrDQ6W50shnWB3YXzVprEi8Fd/w8
        KO6bK03qVlma3YnrQa/mqu9GgzEqb5eK9SV+a9g==
X-Received: by 2002:a05:6e02:120f:: with SMTP id a15mr3766394ilq.109.1634824378754;
        Thu, 21 Oct 2021 06:52:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlO0Zg7XO8nAok+S0+ufULgmQ4M5Q86Wtwg/BpzuD1JY6B5rC8mn9n7PHA/LoD/pAaNX8TKUI6I5aT0avhZjw=
X-Received: by 2002:a05:6e02:120f:: with SMTP id a15mr3766386ilq.109.1634824378574;
 Thu, 21 Oct 2021 06:52:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211020143708.14728-1-lhenriques@suse.de> <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
In-Reply-To: <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 21 Oct 2021 09:52:32 -0400
Message-ID: <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2021-10-20 at 15:37 +0100, Lu=C3=ADs Henriques wrote:
> > This counter will keep track of the number of remote object copies done=
 on
> > copy_file_range syscalls.  This counter will be filesystem per-client, =
and
> > can be accessed from the client debugfs directory.
> >
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> > ---
> > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > 100% sure about the usefulness of this patch, or if this is the best wa=
y
> > to provide the functionality Patrick requested.  Anyway, this is just t=
o
> > get some feedback, hence the RFC.
> >
> > Cheers,
> > --
> > Lu=C3=ADs
> >
> > [0] https://github.com/ceph/ceph/pull/42720
> >
>
> I think this would be better integrated into the stats infrastructure.
>
> Maybe you could add a new set of "copy" stats to struct
> ceph_client_metric that tracks the total copy operations done, their
> size and latency (similar to read and write ops)?

I think it's a good idea to integrate this into "stats" but I think a
local debugfs file for some counters is still useful. The "stats"
module is immature at this time and I'd rather not build any qa tests
(yet) that rely on it.

Can we generalize this patch-set to a file named "op_counters" or
similar and additionally add other OSD ops performed by the kclient?

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

