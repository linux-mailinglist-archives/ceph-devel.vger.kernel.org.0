Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0619719CFBC
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 07:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgDCFZ0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Apr 2020 01:25:26 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35666 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732038AbgDCFZ0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Apr 2020 01:25:26 -0400
Received: by mail-lf1-f65.google.com with SMTP id r17so1159911lff.2
        for <ceph-devel@vger.kernel.org>; Thu, 02 Apr 2020 22:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFx5MDD1lF1WhQe9o8jIFckrz5tTvdxNUFCSgMQ/pPo=;
        b=shlufwgPONYSRhskkPvBl5J2pTXHQVbPqoxNceZArvvDEvebKL0GLVuNIQ+sRBDDZj
         RBp5aN1h2twH28xUujevE2DkpCRlVSh93DIaBjf+2s2nEqmIpE/tEI/fwXU1Dmgc8vRr
         Y7gc4xRNqxqc/bfMvhbnQ3/sVz10R4TgfcZkUa93ErYNK3hqHWtJWgQiMF4eYXWP7Xjn
         LNCeWuQy94kEkKGp478RwjTVYRWXyL0DcC4LK+uuKBAQmoNQ4c2OwsQ8RtyOkDRBiP7X
         BSUOHsFArWrypTUy8WrlOLW7HBfNN1IzAEUHwY4Ojtl1VK6J7p/idG7URt+Xwb4Mmi9g
         YFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFx5MDD1lF1WhQe9o8jIFckrz5tTvdxNUFCSgMQ/pPo=;
        b=hahMAB3Rh9dBtKN1zbjMcFdICKUzikdQk+kzNdOyV6X09u0U3Bc66qq9xEbOiq+tzg
         oRGHhb9Q4B2/zU6LROK5IHM6irOy5sj7pdP/92GwX5RU2d9cNzSZ02GlBvAYQNhE4Ix1
         I+pEIJksbxUeM+XFRXp8sFJClVxU5vDfvq25G2tRAGZZJZzVBppE2s+OHdffg7xZ3iFL
         Vop72p43BjhV4cpNw+DAP8mf1BQmXQ/nbVdkR9a7JGXujqkqMbnlpxgR7RK39Vx1cm3X
         AGkA6XB40C5hrGzykq1LP7HgWNAiJ2PuXJi9YT8XEHwCDW+TIVaXheDaFrwh1AtH4DyF
         wmWA==
X-Gm-Message-State: AGi0PuaYTVKpqsz3Bui80EVdqbVMAIyoIrbbN3ZOzVfoOz2TpojRWjuo
        NOQdH33DVxK71MX8SSbxfe29T+ELVTR9a+F76rg=
X-Google-Smtp-Source: APiQypKxU8D6tc3id+uXLR9xJD8EsQbTHPEsNLfzTsTw50FWzkYdzv/pbRkMRkedOsb4NlrCzlqk8bENqnoDgKg6e5M=
X-Received: by 2002:a05:6512:21b:: with SMTP id a27mr4261329lfo.55.1585891524033;
 Thu, 02 Apr 2020 22:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <878sjqc79i.fsf@suse.com> <alpine.DEB.2.21.2003271410190.4773@piezo.novalocal>
 <CAPPYiwpOOAnNwfPiFMx2zxj7Eh0DCUG+zfALp+8sJSLENDN-Og@mail.gmail.com>
In-Reply-To: <CAPPYiwpOOAnNwfPiFMx2zxj7Eh0DCUG+zfALp+8sJSLENDN-Og@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Fri, 3 Apr 2020 13:25:12 +0800
Message-ID: <CAJE9aONskkr15LQyhchKP_y8vmsD5sgw6NvuhvCwhFS_v5r7SA@mail.gmail.com>
Subject: Re: [ceph-users] Re: v15.2.0 Octopus released
To:     Mazzystr <mazzystr@gmail.com>
Cc:     Sage Weil <sage@newdream.net>, ceph-announce@ceph.io,
        ceph-users@ceph.io, dev <dev@ceph.io>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io,
        Ken Dreyer <kdreyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Mar 28, 2020 at 1:29 AM Mazzystr <mazzystr@gmail.com> wrote:
>
> What about the missing dependencies for octopus on el8?  (looking at yoooou
> ceph-mgr!)

hi Mazzystr,

regarding to the dependencies of ceph-mgr, probably you could enable
the corp repo[0] for installing them, before they are included by
EPEL8.

---
[0] https://copr.fedorainfracloud.org/coprs/ktdreyer/ceph-el8/

>
> On Fri, Mar 27, 2020 at 7:15 AM Sage Weil <sage@newdream.net> wrote:
>
> > One word of caution: there is one known upgrade issue if you
> >
> >  - upgrade from luminous to nautilus, and then
> >  - run nautilus for a very short period of time (hours), and then
> >  - upgrade from nautilus to octopus
> >
> > that prevents OSDs from starting.  We have a fix that will be in 15.2.1,
> > but until that is out, I would recommend against the double-upgrade.  If
> > you have been running nautilus for a while (days) you should be fine.
> >
> > sage
> >
> >
> > https://tracker.ceph.com/issues/44770
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
> >
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io



-- 
Regards
Kefu Chai
