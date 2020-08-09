Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EF823FFA4
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Aug 2020 20:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgHISGo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Aug 2020 14:06:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53169 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726296AbgHISGo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Aug 2020 14:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596996403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ATZD93zD/5kml4N0Lur3x9hiFQeSGJ6fJZXGFW41Qjo=;
        b=fLIlXC9zkAVrEVOy4WLz+zrMl0DImy9r1EPxVGK063KOR1Yztwi41BZG6E843Q0TorIceL
        Vd70raWWMxo294+rD5E8AH4lj21fTLdD9OfWqHe964//uHauR+mKc+k/PZYcdT+TI72xUY
        7nPMFMKiQAb7YF2RVvmf6IOuM7tPfXg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-VjGPB2mbOiCUPtxturRt-g-1; Sun, 09 Aug 2020 14:06:41 -0400
X-MC-Unique: VjGPB2mbOiCUPtxturRt-g-1
Received: by mail-ed1-f71.google.com with SMTP id b23so2452948edj.14
        for <ceph-devel@vger.kernel.org>; Sun, 09 Aug 2020 11:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATZD93zD/5kml4N0Lur3x9hiFQeSGJ6fJZXGFW41Qjo=;
        b=lbO1FGGOdFExwApdHvW5QGbYSMKfnkVajRN1x4mOiF8FvNQnbFjs1n7tlZvPC90lHp
         fZu7DJoziqu7TrEowWDdIEgxGawYc+vyWzeb419+C3v+7RjLbzNa/lWOJrzJssuKgupI
         MKhQV1+vWKfxMG1dis1w0N7TK6D7ITA5jT3Ur8BCeC89A8kEu9DiFo5gP0L4q8vpQnzz
         h6YDj/WBs8RGO2coO6HgVMRYCTrDaBXGxP6CSGZ56Y6/F3Y2KMqW8gKvgpT9ehcCtTa8
         UXURAIwz05ufh7nbkYhDlf2mOu8tgmMxCFiSHMZ48lUk9wSSfMtDXLOnMLxk/iX0aLSQ
         h7Gw==
X-Gm-Message-State: AOAM530Jh9cqpsvNbDHPOV4Won/4gWasp/e6sIgvR2FkDOGdhtEGpyDu
        IzpQBnURjrLTrqGWc7WV9MiaL5JggzI0+7vyhcFCYx/lRyQleBSVfnWpnf3iUwSksp83kcsZein
        SeCul0jlSHehZjCsPMSATnR7M1Ud3UvhitsYEWw==
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr19396738ejf.83.1596996399763;
        Sun, 09 Aug 2020 11:06:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLqdQu7vRltloFG/05zd/F+9/oFGFtH6vc2JCkVRf4G+cJVzGcg3eChnWvhKhTz+um6uw1MSAHMU0xmWl5wbc=
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr19396716ejf.83.1596996399490;
 Sun, 09 Aug 2020 11:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200731130421.127022-1-jlayton@kernel.org> <20200731130421.127022-10-jlayton@kernel.org>
In-Reply-To: <20200731130421.127022-10-jlayton@kernel.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Sun, 9 Aug 2020 14:06:03 -0400
Message-ID: <CALF+zOnQ6diJv4bMbf-HSYmHusT_iE1dAqp-j_kjuqyLqfp-nw@mail.gmail.com>
Subject: Re: [Linux-cachefs] [RFC PATCH v2 09/11] ceph: convert readpages to fscache_read_helper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 9:05 AM Jeff Layton <jlayton@kernel.org> wrote:
> +static int ceph_readpages(struct file *file, struct address_space *mapping,
> +                         struct list_head *page_list, unsigned nr_pages)
>  {
...
> +       int max = fsc->mount_options->rsize >> PAGE_SHIFT;
...
> +               ret = fscache_read_helper_page_list(&req->fscache_req, page_list, max);

Looks like the root of my problems is that the 'max_pages' parameter
given to fscache_read_helper_page_list() does not work for purposes of
limiting the IO to the 'rsize'.  That is, the fscache_io_request.nr_pages
exceeds 'max_pages' and becomes readahead_size.  So even though
max_pages is based on 'rsize', when issue_op() is called, it is for a
fscache_io_request that exceeds 'rsize', resulting in multiple NFS
reads that go over the wire and multiple completions, each of
which end up calling back into io_done() which blows up
because fscache does not expect this.  Looks like
fscache_shape_request() overrides any 'max_pages'
value (actually it is cachefiles_shape_request) , so it's
unclear why the netfs would pass in a 'max_pages' if it is
not honored - seems like a bug maybe or it's not obvious
what the purpose is there.  I tried a custom 'shape' method
and got further, but it blew up on another test, so I'm not sure.

It would be good to know if this somehow works for you but my guess is
you'll see similar failures when rsize < readahead_size == size_of_readpages.

