Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7AB2405CE
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Aug 2020 14:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgHJMY6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Aug 2020 08:24:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbgHJMY6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Aug 2020 08:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597062296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4VPTIyjQNatVrz2VI5RQx2AT8TlRCkUDjcaMy9xwpg8=;
        b=KSyUeIbnCTV7ka3b8fO8EOGSp0IlSfqVGxlZKF9KuwzD93mDuOLBEM2cXWIIWHqDZmWvMD
        nMNHEeqdditwSTnoTvhT5kVyXPqUgEnMDINRiw4SwW/iQuCsOEbIuTU/W/C+OHZ7Q7KPNZ
        Wu06mB6LwTcMClJT7kU3Mk6WuBuMiEU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-ubhDCliDO2Kq0RqUtL9wuw-1; Mon, 10 Aug 2020 08:24:52 -0400
X-MC-Unique: ubhDCliDO2Kq0RqUtL9wuw-1
Received: by mail-ed1-f70.google.com with SMTP id v11so3157825edr.13
        for <ceph-devel@vger.kernel.org>; Mon, 10 Aug 2020 05:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VPTIyjQNatVrz2VI5RQx2AT8TlRCkUDjcaMy9xwpg8=;
        b=mPrQ5cHdp926bQijOsLN62+uf7x9ITMmmNLvF/nhd24s058WXIsA5mZdYQdGt5WvoB
         5SArjma/yW1uWqOVGuZKfnbN9aOU+ZWJB8GoZ/K8vwmozDDBIub2MMJHYAYMCU9LpEk1
         gIeMB54MLbmPFFbFn8btK5Hb4a7eI2u90rvnxa27yYSVYu5TdeewD0Do+JCJypMBfPDr
         7f7MWXierLgHDpDdSqmuE/6o6oQh/Zm/w/KormjGqAhOOJD2UB7MYlMy2QUJFMmJgEXQ
         WCQ4USz7cmQDheOqyC1VeuVwWG4JnaZu3FZqBRtFhUJsIuWjTw2XdDUHN4xp8raxn2A4
         6+5A==
X-Gm-Message-State: AOAM532DfkUuEiRXfqg+c7feVh9c6Wl8KWovFbsGCEKp5jdpJFlQkMPK
        IB65aaqB4Qmx0c/FkeUU8kIwtCwLV4xzoVCcLvuyMV3vybH9OHcUXQ1xsp3uXfw4lA3J42ecPUh
        e+vrQdZb7X1zCTmj4eBc+0IBKD0nc7yl1b54t5Q==
X-Received: by 2002:a17:906:f202:: with SMTP id gt2mr20809415ejb.70.1597062290986;
        Mon, 10 Aug 2020 05:24:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6NcnlRx+gWMAH6n6n32ohWZ+kmzr6P2P2AjBXSySl16e/qj8u/joyJDbVruYQCoj8QMzqAP/6DO1lTY6mw0s=
X-Received: by 2002:a17:906:f202:: with SMTP id gt2mr20809400ejb.70.1597062290725;
 Mon, 10 Aug 2020 05:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200731130421.127022-1-jlayton@kernel.org> <20200731130421.127022-10-jlayton@kernel.org>
 <CALF+zOnS9faaap1pZ_HfPzy2q4R_+HP84S02GxhrzWMD1WOYtg@mail.gmail.com> <b0f10cd60aa33d0bcc63e18a81410b9b8db298fa.camel@kernel.org>
In-Reply-To: <b0f10cd60aa33d0bcc63e18a81410b9b8db298fa.camel@kernel.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Mon, 10 Aug 2020 08:24:14 -0400
Message-ID: <CALF+zOnEhBHdHvKnmTEKb8KHi8G92G_CHNUwHaOoJmS5_vVNOQ@mail.gmail.com>
Subject: Re: [Linux-cachefs] [RFC PATCH v2 09/11] ceph: convert readpages to fscache_read_helper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        linux-cachefs@redhat.com
Content-Type: multipart/mixed; boundary="00000000000086129f05ac850a2c"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--00000000000086129f05ac850a2c
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 10, 2020 at 7:09 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Sun, 2020-08-09 at 11:09 -0400, David Wysochanski wrote:
> > On Fri, Jul 31, 2020 at 9:05 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > Convert ceph_readpages to use the fscache_read_helper. With this we can
> > > rip out a lot of the old readpage/readpages infrastructure.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/addr.c | 209 +++++++------------------------------------------
> > >  1 file changed, 28 insertions(+), 181 deletions(-)
> > >
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index cee497c108bb..8905fe4a0930 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -377,76 +377,23 @@ static int ceph_readpage(struct file *filp, struct page *page)
> > >         return err;
> > >  }
> > >
> > > -/*
> > > - * Finish an async read(ahead) op.
> > > - */
> > > -static void finish_read(struct ceph_osd_request *req)
> > > -{
> > > -       struct inode *inode = req->r_inode;
> > > -       struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > -       struct ceph_osd_data *osd_data;
> > > -       int rc = req->r_result <= 0 ? req->r_result : 0;
> > > -       int bytes = req->r_result >= 0 ? req->r_result : 0;
> > > -       int num_pages;
> > > -       int i;
> > > -
> > > -       dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
> > > -       if (rc == -EBLACKLISTED)
> > > -               ceph_inode_to_client(inode)->blacklisted = true;
> > > -
> > > -       /* unlock all pages, zeroing any data we didn't read */
> > > -       osd_data = osd_req_op_extent_osd_data(req, 0);
> > > -       BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
> > > -       num_pages = calc_pages_for((u64)osd_data->alignment,
> > > -                                       (u64)osd_data->length);
> > > -       for (i = 0; i < num_pages; i++) {
> > > -               struct page *page = osd_data->pages[i];
> > > -
> > > -               if (rc < 0 && rc != -ENOENT)
> > > -                       goto unlock;
> > > -               if (bytes < (int)PAGE_SIZE) {
> > > -                       /* zero (remainder of) page */
> > > -                       int s = bytes < 0 ? 0 : bytes;
> > > -                       zero_user_segment(page, s, PAGE_SIZE);
> > > -               }
> > > -               dout("finish_read %p uptodate %p idx %lu\n", inode, page,
> > > -                    page->index);
> > > -               flush_dcache_page(page);
> > > -               SetPageUptodate(page);
> > > -unlock:
> > > -               unlock_page(page);
> > > -               put_page(page);
> > > -               bytes -= PAGE_SIZE;
> > > -       }
> > > -
> > > -       ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_latency,
> > > -                                req->r_end_latency, rc);
> > > -
> > > -       kfree(osd_data->pages);
> > > -}
> > > -
> > > -/*
> > > - * start an async read(ahead) operation.  return nr_pages we submitted
> > > - * a read for on success, or negative error code.
> > > - */
> > > -static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
> > > -                     struct list_head *page_list, int max)
> > > +static int ceph_readpages(struct file *file, struct address_space *mapping,
> > > +                         struct list_head *page_list, unsigned nr_pages)
> > >  {
> > > -       struct ceph_osd_client *osdc =
> > > -               &ceph_inode_to_client(inode)->client->osdc;
> > > +       struct inode *inode = file_inode(file);
> > >         struct ceph_inode_info *ci = ceph_inode(inode);
> > > -       struct page *page = lru_to_page(page_list);
> > > -       struct ceph_vino vino;
> > > -       struct ceph_osd_request *req;
> > > -       u64 off;
> > > -       u64 len;
> > > -       int i;
> > > -       struct page **pages;
> > > -       pgoff_t next_index;
> > > -       int nr_pages = 0;
> > > +       struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > +       struct ceph_file_info *fi = file->private_data;
> > > +       struct ceph_rw_context *rw_ctx;
> > > +       struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
> > >         int got = 0;
> > >         int ret = 0;
> > > +       int max = fsc->mount_options->rsize >> PAGE_SHIFT;
> >
> > Have you ran tests with different values of rsize?
> > Specifically, rsize < readahead_size == size_of_readpages
> >
> > I'm seeing a lot of problems with NFS when varying rsize are used wrt
> > readahead values.  Specifically I'm seeing panics because fscache
> > expects a 1:1 mapping of issue_op() to io_done() calls, and I get
> > panics because multiple read completions are trying to unlock the
> > same pages inside fscache_read_done().
> >
> > My understanding is afs does not have such 'rsize' limitation, so it
> > may not be an area that is well tested.  It could be my implementation
> > of the NFS conversion though, as I thinkwhat needs to happen is the
> > respect the above 1:1 mapping of issue_op() to io_done() calls, and my
> > initial implementation did not do that.
> >
> > FWIW, specifically this unit test was originally failing for me with a panic.
> > Sun 09 Aug 2020 11:03:22 AM EDT: 1. On NFS client, install and enable
> > cachefilesd
> > Sun 09 Aug 2020 11:03:22 AM EDT: 2. On NFS client, mount -o
> > vers=4.1,fsc,rsize=16384 127.0.0.1:/export/dir1 /mnt/dir1
> > Sun 09 Aug 2020 11:03:22 AM EDT: 3. On NFS client, dd if=/dev/zero
> > of=/mnt/dir1/file1.bin bs=65536 count=1
> > Sun 09 Aug 2020 11:03:22 AM EDT: 4. On NFS client, echo 3 >
> > /proc/sys/vm/drop_caches
> > Sun 09 Aug 2020 11:03:22 AM EDT: 5. On NFS client, ./nfs-readahead.sh
> > set /mnt/dir1 65536
> > Sun 09 Aug 2020 11:03:23 AM EDT: 8. On NFS client, echo 3 >
> > /proc/sys/vm/drop_caches
> > Sun 09 Aug 2020 11:03:23 AM EDT: 9. On NFS client, dd
> > if=/mnt/dir1/file1.bin of=/dev/null
> >
> >
>
> I haven't tested much with varying rsize and wsize (setting them on
> cephfs is pretty rare), but I'll plan to. What's in nfs-readahead.sh?
>
>

See attached.

--00000000000086129f05ac850a2c
Content-Type: application/x-shellscript; name="nfs-readahead.sh"
Content-Disposition: attachment; filename="nfs-readahead.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_kdohmi9h0>
X-Attachment-Id: f_kdohmi9h0

IyEvYmluL2Jhc2gKIyBzaG93fHNldHxkaXNhYmxlIHJlYWRhaGVhZCBmb3IgYSBzcGVjaWZpYyBt
b3VudCBwb2ludAojIFVzZWZ1bCBmb3IgdGhpbmdzIGxpa2UgTkZTIGFuZCBpZiB5b3UgZG9uJ3Qg
a25vdyAvIGNhcmUgYWJvdXQgdGhlIGJhY2tpbmcgZGV2aWNlCiMKIyBUbyB0aGUgZXh0ZW50IHBv
c3NpYmxlIHVuZGVyIGxhdywgUmVkIEhhdCwgSW5jLiBoYXMgZGVkaWNhdGVkIGFsbCBjb3B5cmln
aHQKIyB0byB0aGlzIHNvZnR3YXJlIHRvIHRoZSBwdWJsaWMgZG9tYWluIHdvcmxkd2lkZSwgcHVy
c3VhbnQgdG8gdGhlCiMgQ0MwIFB1YmxpYyBEb21haW4gRGVkaWNhdGlvbi4gVGhpcyBzb2Z0d2Fy
ZSBpcyBkaXN0cmlidXRlZCB3aXRob3V0IGFueSB3YXJyYW50eS4KIyBTZWUgPGh0dHA6Ly9jcmVh
dGl2ZWNvbW1vbnMub3JnL3B1YmxpY2RvbWFpbi96ZXJvLzEuMC8+LgojCkVfQkFEQVJHUz0yMgpm
dW5jdGlvbiBteXVzYWdlKCkgewogICAgICAgIGVjaG8gIlVzYWdlOiBgYmFzZW5hbWUgJDBgIHNl
dHxzaG93fGRpc2FibGUgPG1vdW50LXBvaW50PiBbcmVhZC1haGVhZC1rYl0iCn0KaWYgWyAkIyAt
Z3QgMyAtbyAkIyAtbHQgMiBdOyB0aGVuCiAgICAgICAgbXl1c2FnZQogICAgICAgIGV4aXQgJEVf
QkFEQVJHUwpmaQpNTlQ9JHsyJS99CkJERVY9JChncmVwICRNTlQgL3Byb2Mvc2VsZi9tb3VudGlu
Zm8gfCBhd2sgJ3sgcHJpbnQgJDMgfScpCmlmIFsgJCMgLWVxIDMgLWEgJDEgPT0gInNldCIgXTsg
dGhlbgogICAgICAgIGVjaG8gJDMgPiAvc3lzL2NsYXNzL2JkaS8kQkRFVi9yZWFkX2FoZWFkX2ti
CmVsaWYgWyAkIyAtZXEgMiAtYSAkMSA9PSAiZGlzYWJsZSIgXTsgdGhlbgogICAgICAgIGVjaG8g
MCA+IC9zeXMvY2xhc3MvYmRpLyRCREVWL3JlYWRfYWhlYWRfa2IKZWxpZiBbICQjIC1lcSAyIC1h
ICQxID09ICJzaG93IiBdOyB0aGVuCiAgICAgICAgZWNobyAiJE1OVCAkQkRFViAvc3lzL2NsYXNz
L2JkaS8kQkRFVi9yZWFkX2FoZWFkX2tiID0gIiQoY2F0IC9zeXMvY2xhc3MvYmRpLyRCREVWL3Jl
YWRfYWhlYWRfa2IpCmVsc2UKICAgICAgICBteXVzYWdlCiAgICAgICAgZXhpdCAkRV9CQURBUkdT
CmZpCg==
--00000000000086129f05ac850a2c--

