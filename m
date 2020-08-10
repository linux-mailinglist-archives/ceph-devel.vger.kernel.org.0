Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B1240D33
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Aug 2020 20:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgHJS4A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Aug 2020 14:56:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57692 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728103AbgHJS4A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Aug 2020 14:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597085758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8w76Vsz8sqy2fap/GPzs/EITXjOm2GkjBqV8wsyiptw=;
        b=fTthIwfTlV6DzE6EoSh81bLvCoVtw1Q8AZSdB6K55zXT013dIplWTdEhPy0HUKfYVok9Hi
        VOoXgD0iU70LQ9xeYGkNajHeGAguJE4sZYc4lqTiENY6m2gVeYIt2guzCAeFaZQ9OWLuCv
        L7KTbTEUCWtqt9lr6w9ofHp/QgBLObY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-sgIYAqOvNn-lS83MqbR71w-1; Mon, 10 Aug 2020 14:55:56 -0400
X-MC-Unique: sgIYAqOvNn-lS83MqbR71w-1
Received: by mail-ej1-f69.google.com with SMTP id g18so4233565ejm.4
        for <ceph-devel@vger.kernel.org>; Mon, 10 Aug 2020 11:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8w76Vsz8sqy2fap/GPzs/EITXjOm2GkjBqV8wsyiptw=;
        b=o+eLOcR4ZmE3BQq3qP1nvCvphLQ71T8nEH9PjiVwlq5JhKlrM9frBQg/t7Qys991Bt
         nFVjcwEHfg+G2N8ish+aFbufu1iwzjxToBTGeu31H+g+gELzyt0ZMgMc4ZbbojlPvnI6
         S+5jmpIx3r4lAKNKN+zM9vbNtqk5icIJxKby594kUcOTKz+wmfC7/77TEQHTeGTVk6E/
         SYPN3Ph2YTOYbB9U1Q66JplYI5qAXuKfZ6v3PjsDbBD4sQVFi5RLvIgpN2UaV95oUSDv
         j0nWp/7/iIa5R1E8DjZeaxPgAaoIwQh/ag2IjUu4+hAOR1u09TkuTtcBRPdpJl0RLtgx
         53DA==
X-Gm-Message-State: AOAM531ZtsjQidFYQNg+juZWk5ysilcfjHkn60rphZ9sPiD9UHfXB/tS
        8YT224lZSo0BpuAkUIIxjoIKl5BiVEjD21cNv6D89qokbMYCsblyIBy44NJCInDxEnv0Jlagw0t
        t3/0/Y/JouSkxN4QTbt6eP8KCImvvCXofsMg2gA==
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr24028524ejf.83.1597085747774;
        Mon, 10 Aug 2020 11:55:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmPgEiJFl+cVO4p6h9RwGpYGushiDcIiZ53mbVILvOEjZU6WkjJFiU4WftR8yieNxMBkcaQVmxvMETG04IOU8=
X-Received: by 2002:a17:906:a4b:: with SMTP id x11mr24028507ejf.83.1597085747584;
 Mon, 10 Aug 2020 11:55:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200731130421.127022-1-jlayton@kernel.org> <20200731130421.127022-10-jlayton@kernel.org>
 <CALF+zOnQ6diJv4bMbf-HSYmHusT_iE1dAqp-j_kjuqyLqfp-nw@mail.gmail.com>
 <526038.1597054155@warthog.procyon.org.uk> <CALF+zO=K8iE5y7_5MPS4Zg+stUmY4FQobop1DnsS71Dpn_YpOg@mail.gmail.com>
In-Reply-To: <CALF+zO=K8iE5y7_5MPS4Zg+stUmY4FQobop1DnsS71Dpn_YpOg@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 10 Aug 2020 14:55:11 -0400
Message-ID: <CALF+zOmZK5uc+JnCtxgxeFY=Xcgm6FN4c+YPKsxoKQy5WpaDng@mail.gmail.com>
Subject: Re: [Linux-cachefs] [RFC PATCH v2 09/11] ceph: convert readpages to fscache_read_helper
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, idryomov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 10, 2020 at 9:50 AM David Wysochanski <dwysocha@redhat.com> wrote:
>
> On Mon, Aug 10, 2020 at 6:09 AM David Howells <dhowells@redhat.com> wrote:
> >
> > David Wysochanski <dwysocha@redhat.com> wrote:
> >
> > > Looks like fscache_shape_request() overrides any 'max_pages' value (actually
> > > it is cachefiles_shape_request) , so it's unclear why the netfs would pass
> > > in a 'max_pages' if it is not honored - seems like a bug maybe or it's not
> > > obvious
> >
> > I think the problem is that cachefiles_shape_request() is applying the limit
> > too early.  It's using it to cut down the number of pages in the original
> > request (only applicable to readpages), but then the shaping to fit cache
> > granules can exceed that, so it needs to be applied later also.
> >
> > Does the attached patch help?
> >
> > David
> > ---
> > diff --git a/fs/cachefiles/content-map.c b/fs/cachefiles/content-map.c
> > index 2bfba2e41c39..ce05cf1d9a6e 100644
> > --- a/fs/cachefiles/content-map.c
> > +++ b/fs/cachefiles/content-map.c
> > @@ -134,7 +134,8 @@ void cachefiles_shape_request(struct fscache_object *obj,
> >         _enter("{%lx,%lx,%x},%llx,%d",
> >                start, end, max_pages, i_size, shape->for_write);
> >
> > -       if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE) {
> > +       if (start >= CACHEFILES_SIZE_LIMIT / PAGE_SIZE ||
> > +           max_pages < CACHEFILES_GRAN_PAGES) {
> >                 shape->to_be_done = FSCACHE_READ_FROM_SERVER;
> >                 return;
> >         }
> > @@ -144,10 +145,6 @@ void cachefiles_shape_request(struct fscache_object *obj,
> >         if (shape->i_size > CACHEFILES_SIZE_LIMIT)
> >                 i_size = CACHEFILES_SIZE_LIMIT;
> >
> > -       max_pages = round_down(max_pages, CACHEFILES_GRAN_PAGES);
> > -       if (end - start > max_pages)
> > -               end = start + max_pages;
> > -
> >         granule = start / CACHEFILES_GRAN_PAGES;
> >         if (granule / 8 >= object->content_map_size) {
> >                 cachefiles_expand_content_map(object, i_size);
> > @@ -185,6 +182,10 @@ void cachefiles_shape_request(struct fscache_object *obj,
> >                 start = round_down(start, CACHEFILES_GRAN_PAGES);
> >                 end   = round_up(end, CACHEFILES_GRAN_PAGES);
> >
> > +               /* Trim to the maximum size the netfs supports */
> > +               if (end - start > max_pages)
> > +                       end = round_down(start + max_pages, CACHEFILES_GRAN_PAGES);
> > +
> >                 /* But trim to the end of the file and the starting page */
> >                 eof = (i_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> >                 if (eof <= shape->proposed_start)
> >
>
> I tried this and got the same panic - I think i_size is the culprit
> (it is larger than max_pages).  I'll send you a larger trace offline
> with cachefiles/fscache debugging enabled if that helps, but below is
> some custom tracing that may be enough because it shows before / after
> shaping values.
>

FWIW, after testing the aforementioned patch, and tracing it,
it is not i_size after all.  I added this small patch on top of the
patch to cachefiles_shape_request() and no more panics.  Though
this may not address the full underlying issues, it at least gets
past this point and max_pages seems to work better.

---
diff --git a/fs/fscache/read_helper.c b/fs/fscache/read_helper.c
index a464c3e3188a..fa67339e7304 100644
--- a/fs/fscache/read_helper.c
+++ b/fs/fscache/read_helper.c
@@ -318,8 +318,8 @@ static int fscache_read_helper(struct
fscache_io_request *req,
        switch (type) {
        case FSCACHE_READ_PAGE_LIST:
                shape.proposed_start = lru_to_page(pages)->index;
-               shape.proposed_nr_pages =
-                       lru_to_last_page(pages)->index -
shape.proposed_start + 1;
+               shape.proposed_nr_pages = min_t(unsigned int, max_pages,
+                       lru_to_last_page(pages)->index -
shape.proposed_start + 1);
                break;

        case FSCACHE_READ_LOCKED_PAGE:

