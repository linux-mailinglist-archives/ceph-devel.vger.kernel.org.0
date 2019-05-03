Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76096126F9
	for <lists+ceph-devel@lfdr.de>; Fri,  3 May 2019 06:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfECEwp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 May 2019 00:52:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37145 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfECEwo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 May 2019 00:52:44 -0400
Received: by mail-ot1-f68.google.com with SMTP id r20so4233240otg.4
        for <ceph-devel@vger.kernel.org>; Thu, 02 May 2019 21:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s13Zs5phwAtmWC+VDnEg4ynsdBDHybljOfQ34gS1hPs=;
        b=qU6YvSWCoQMJOz/E1ToP4PN/F1M79xYAsgGyp6GPwmN6CJ9TR0pYwsIvqDjJxA8ztl
         HaQD0dSGQO13MfzVIjUtvrHe3BZhIgy9RJKEidXdjJOVKbyuqX0LKJ78i038brYizeIA
         AwSNoEf9j64FBIHL0IYgABokAIkGnjT73nBVUIYSU3ywNJkisz+KHjyuGUhdXgXLpBkM
         SS8jRRyr6WVtpKj6rQAYFKRPRKzNyeArDTUC4iQAWl0pzqml/2rvbp1xGf1WxdfBvE8+
         Uta7QkJYRQfweA8OHhS5Fq+hfeTohxhHfiPkit86xNWDlU5L7JOxmXgrCgBCQJZLxG6y
         osuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s13Zs5phwAtmWC+VDnEg4ynsdBDHybljOfQ34gS1hPs=;
        b=q21PKIBnQiuCsxSlVOlhUOSftmey5pridSTJNvZW59Zunp7lYitcD/WcS7tzx5Nxfq
         q46gUEKlIYH+R2LQmCEKrspVunwFvqNI50uwiKSdeM6oJmqpjAmrysmTDvUsExsDmB+t
         ULfyXcYxR4Q1IdSDawji+wU0CfGKLl8BkTeU+UbPZGS9ZmO/oPGIaLrCRSnG80i4O7z9
         jbAO2cHowMMSUsDdmrw6RSqZUZMS+N3VoDKxZDeJjzh6+j6xvtg26X2OXT1wu2hOKxkF
         3Ja+VtuRgzlaJx1fGu9txIt+u9ez9/40Xm6w4Jgm3LxJM/P1qVG4UqTHWiZZOPDvGM25
         UxdQ==
X-Gm-Message-State: APjAAAWVBUZpOeAtwjRgKR/TSts0G38omKX3zZYpCKb+U3R1rThlXKbt
        fZCnaow3M7JGvtMC5sGKsFxAGvPGOWK+n+AvSl4FOH2HCiI=
X-Google-Smtp-Source: APXvYqwqGKA0knZq4BOZrLMAd96oF8uXy1KLr4SSmwWG8cZv3cxNw+1f4/Dhv+xgXhdrhCpp9mVwbWg23F0ozwsjyAk=
X-Received: by 2002:a9d:7c94:: with SMTP id q20mr2197336otn.247.1556859163414;
 Thu, 02 May 2019 21:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190412104207.GA29167@jerryopenix> <30fa5e49d56591fe2ecd6eae1caa98ce@suse.de>
 <20190415122240.GA7819@jerryopenix> <484935ae3aeb0ee6a59f93c3c727ba36@suse.de>
 <20190416085820.GA4711@jerryopenix> <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix> <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix> <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix> <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
 <alpine.DEB.2.11.1905021323340.19445@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1905021323340.19445@piezo.novalocal>
From:   kefu chai <tchaikov@gmail.com>
Date:   Fri, 3 May 2019 12:52:31 +0800
Message-ID: <CAJE9aONbRuFrx40tyaUXNonFTvAMt-tQ=sG9rShezzR_J=8uOQ@mail.gmail.com>
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
To:     Sage Weil <sage@newdream.net>
Cc:     Roman Penyaev <rpenyaev@suse.de>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>,
        "Liu, Chunmei" <chunmei.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 2, 2019 at 9:26 PM Sage Weil <sage@newdream.net> wrote:
>
> On Tue, 30 Apr 2019, Roman Penyaev wrote:
> > On 2019-04-19 16:31, Liu, Changcheng wrote:
> > > Hi Roman,
> > >   I found that why ceph/msg/async/rdma/iwarp(x722) doesn't work on
> > > ceph master branch.
> > >   The problem is triggered by below commit:
> > >
> > > https://github.com/ceph/ceph/pull/20172/commits/fdde016301ae329f76c621337c384ac60aa0d210
> > >
> > >   Below is the basic program model extracted from
> > > ceph/msg/async/rdma/iwarp to show how the problem is triggered:
> >
> > Hi Changcheng,
> >
> > Indeed fork() also changes credentials (see copy_creds() in kernel for
> > details),
> > like setuid() does, so there are two known places in ceph, after which uverbs
> > calls return -EACESS:
> >
> >   o setuid() (see global_init())
> >   o daemon() (see global_init_daemonize())
> >
> > My question is why you daemonize your ceph services and do not rely on
> > systemd,
> > which does fork() on its own and runs each service with '-f' flag, which means
> > do not daemonize?  So I would not daemonize services and this can be a simple
> > solution.
>
> The daemonize behavior predates systemd (and upstart).  At this point it
> is only there for legacy reasons and to avoid breaking things for the
> Devuan sysvinit hold-outs.  (And vstart still daemonizes.)  We could
> probably get away with ripping it out...

in crimson-osd, we are also struggling with the daemonize feature.
probably we can have a command like http://www.libslack.org/daemon/,
to read the settings and do the daemonize on behalf of the
ceph-{osd,mgr,mon,mds} and radosgw daemons when it's necessary without
breaking sysvinit systems and vstart.sh.

>
> sage
>
> >
> > With setuid() is not that easy.  The most straightforward way is to move
> > mc_bootstrap.get_monmap_and_config() after setuid() call.  At the bottom of
> > the email there is a small patch which can fix the problem (I hope does not
> > introduce something new). Would be great if you can check it.
> >
> > --
> > Roman
> >
> >
> > diff --git a/src/global/global_init.cc b/src/global/global_init.cc
> > index eb8bbfd1a4db..de647be768bd 100644
> > --- a/src/global/global_init.cc
> > +++ b/src/global/global_init.cc
> > @@ -147,18 +147,6 @@ void global_pre_init(
> >      cct->_log->start();
> >    }
> >
> > -  if (!conf->no_mon_config) {
> > -    // make sure our mini-session gets legacy values
> > -    conf.apply_changes(nullptr);
> > -
> > -    MonClient mc_bootstrap(g_ceph_context);
> > -    if (mc_bootstrap.get_monmap_and_config() < 0) {
> > -      cct->_log->flush();
> > -      cerr << "failed to fetch mon config (--no-mon-config to skip)"
> > -          << std::endl;
> > -      _exit(1);
> > -    }
> > -  }
> >    if (!cct->_log->is_started()) {
> >      cct->_log->start();
> >    }
> > @@ -313,6 +301,28 @@ global_init(const std::map<std::string,std::string>
> > *defaults,
> >    }
> >  #endif
> >
> > +  //
> > +  // Utterly important to run first network connection after setuid().
> > +  // In case of rdma transport uverbs kernel module starts returning
> > +  // -EACCESS on each operation if credentials has been changed, see
> > +  // callers of ib_safe_file_access() for details.
> > +  //
> > +  // fork() syscall also matters, so daemonization won't work in case
> > +  // of rdma.
> > +  //
> > +  if (!g_conf()->no_mon_config) {
> > +    // make sure our mini-session gets legacy values
> > +    g_conf().apply_changes(nullptr);
> > +
> > +    MonClient mc_bootstrap(g_ceph_context);
> > +    if (mc_bootstrap.get_monmap_and_config() < 0) {
> > +      g_ceph_context->_log->flush();
> > +      cerr << "failed to fetch mon config (--no-mon-config to skip)"
> > +          << std::endl;
> > +      _exit(1);
> > +    }
> > +  }
> > +
> >
> >
> >
> >



-- 
Regards
Kefu Chai
