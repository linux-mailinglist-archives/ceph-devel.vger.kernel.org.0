Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1931F827
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 18:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfEOQHT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 12:07:19 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:35484 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfEOQHT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 12:07:19 -0400
Received: by mail-it1-f194.google.com with SMTP id u186so1043811ith.0
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rXII2FXntNdD5N8xDv1VViUChJrMS9S4Qg/2bjFGLKs=;
        b=MsfVO7jkZBnlWLE2bFVKH949OrG0imoFvzXdpePtoeCC0quMNNCltSrZT2UFDJ8On3
         YylmXEEPE8IpQ3uoTp5Gxhl1WYn74DqHO3SDx9U8TQdXVTttBaNPpCaVQXfii3bMQUiG
         FoyjOTrf28hUVpOYfWEvRrydmPmwG0IQkveIqoTapXVLw0M+QwW9/Godigb9ENmEc93d
         elvWgcnJ1tZ75e9yqFhkdCv9GppOqoLspDsaOCv49bPfNFo4PsbOh6XD6zhz27t67TTa
         AQ+PTWbusCWZIyuozmR5mu+1jFAJt3zgQe1ArKU+LhQWUetIm1Kecwi6lsj6IVXQm7KG
         x1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rXII2FXntNdD5N8xDv1VViUChJrMS9S4Qg/2bjFGLKs=;
        b=MIyyHTrzdTVhUawfokaNsNiV/NQCPxS20J+CPSwBtjFHgmPeTUAB06HIIKPk5s3deh
         KvQMZAgp0LbbirSxdJ3qE3lxeO89BypUehjcQpaWNCq+AysLVL4HjiW92kVGPdWPmXL5
         PvJJow3QpAscrHa3Pv6geZe9qFmO5+gdr5+mG2Rjy7YYPeI+en+4Ru+4KmeF2/UV+mya
         VtnIEt8CQ+FCqifFU8aHvwyan8uYTGgrC4lhHSQMMOS9fWLq8IhwygfwJ0EJc6CLWC0j
         e7GcSrw9ncCTt0mIJdsU548x2r5raUxWfnA0Awuwyf0U99j9TBOu7ZskdwJbhdHfIASB
         b3PQ==
X-Gm-Message-State: APjAAAVlGk1YPWmVN7cCjmTO99s/0zen6uYk0QdyeEbSCb9/Gpcy/bxj
        MNa/38yG9bys6LrHMI3VeYus0RkqcPg9xx/FCOc=
X-Google-Smtp-Source: APXvYqwi8C18cV2n699O17cAzTFDv+ocXtvg8PDSWxIOomuNwkfKzzguPOsD8XNRevIytkYBu4x6KBLogzFERSLDuXM=
X-Received: by 2002:a24:dac7:: with SMTP id z190mr8267209itg.57.1557936438869;
 Wed, 15 May 2019 09:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190515145639.5206-1-ddiss@suse.de> <alpine.DEB.2.11.1905151546250.24522@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1905151546250.24522@piezo.novalocal>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 15 May 2019 18:07:07 +0200
Message-ID: <CAOi1vP-z4vevmdir-i7cNd1DxfqjNUc194TB2Vmh7hQAXkYEhg@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix "ceph.dir.rctime" vxattr value
To:     Sage Weil <sage@newdream.net>
Cc:     David Disseldorp <ddiss@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 15, 2019 at 5:47 PM Sage Weil <sage@newdream.net> wrote:
>
> On Wed, 15 May 2019, David Disseldorp wrote:
> > The vxattr value incorrectly places a "09" prefix to the nanoseconds
> > field, instead of providing it as a zero-pad width specifier after '%'.
> >
> > Link: https://tracker.ceph.com/issues/39943
> > Fixes: 3489b42a72a4 ("ceph: fix three bugs, two in ceph_vxattrcb_file_layout()")
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >
> > @Yan, Zheng: given that the padding has been broken for so long, another
> >              option might be to drop the "09" completely and keep it
> >              variable width.
>
> Since the old value was just wrong, I'd just make it correct here and not
> worry about compatibility with a something that wasn't valid anyway.

(Chiming in because I can't parse whether you want David to keep "09"
or drop it...)

FWIW it's zero-padded in ceph_read_dir():

  "rctime:    %10lld.%09ld\n"

Not sure if anyone actually mounts with -o dirstat and does reads on
directories, but I'd keep "09" for consistency.

Thanks,

                Ilya
